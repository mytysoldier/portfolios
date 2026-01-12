// Supabase Edge Function - OpenAI API統合
// @ts-ignore - DenoランタイムではURLインポートがサポートされています
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
// @ts-ignore - DenoランタイムではURLインポートがサポートされています
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// Deno環境の型宣言
declare const Deno: {
  env: {
    get(key: string): string | undefined
  }
}

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// 型定義
interface AnalysisPayload {
  emotion: string
  title: string
  summary: string
  advice: string
}

interface WhisperResponse {
  text: string
}

interface ChatMessage {
  role: string
  content: string
}

interface ChatRequest {
  model: string
  messages: ChatMessage[]
  response_format: {
    type: string
  }
}

interface ChatResponse {
  choices: Array<{
    index: number
    message: {
      role: string
      content: string
    }
  }>
}

// OpenAI APIキーの取得
function getOpenAIApiKey(): string {
  const apiKey = Deno.env.get('OPENAI_API_KEY')
  if (!apiKey || apiKey === '') {
    throw new Error('OPENAI_API_KEYが設定されていません')
  }
  return apiKey
}

// Whisper APIで音声をテキストに変換
async function transcribeAudio(
  audioFile: File,
  model: string = 'whisper-1',
  temperature: number = 0
): Promise<string> {
  const apiKey = getOpenAIApiKey()
  const formData = new FormData()
  formData.append('file', audioFile)
  formData.append('model', model)
  formData.append('temperature', temperature.toString())

  const response = await fetch('https://api.openai.com/v1/audio/transcriptions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
    },
    body: formData,
  })

  if (!response.ok) {
    const errorText = await response.text()
    console.error(`Whisper API error (${response.status}):`, errorText)
    throw new Error(`音声変換に失敗しました (status: ${response.status})`)
  }

  const data: WhisperResponse = await response.json()
  return data.text
}

// GPT-4o-miniで感情分析を実行
async function analyzeEmotion(
  transcript: string,
  model: string = 'gpt-4o-mini'
): Promise<AnalysisPayload> {
  const apiKey = getOpenAIApiKey()
  
  const systemPrompt = `あなたは感情分析AIです。以下のユーザーの音声テキストを読み、感情カテゴリー・タイトル・要約・アドバイスを JSON 形式で出力してください。
感情カテゴリーは次のいずれかです：Happy, Calm, Neutral, Sad, Angry, Hurt, Overwhelmed`

  const payload: ChatRequest = {
    model: model,
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: transcript }
    ],
    response_format: {
      type: 'json_object'
    }
  }

  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  })

  if (!response.ok) {
    const errorText = await response.text()
    console.error(`Chat completion API error (${response.status}):`, errorText)
    throw new Error(`感情分析に失敗しました (status: ${response.status})`)
  }

  const data: ChatResponse = await response.json()
  const contentString = data.choices[0]?.message?.content
  
  if (!contentString) {
    throw new Error('解析結果の読み取りに失敗しました')
  }

  // JSON文字列をパース
  const sanitizedJson = sanitizeJSONString(contentString)
  return parseAnalysisPayload(sanitizedJson)
}

// JSON文字列をクリーンアップ
function sanitizeJSONString(str: string): string {
  const trimmed = str.trim()
  const start = trimmed.indexOf('{')
  const end = trimmed.lastIndexOf('}')
  
  if (start !== -1 && end !== -1 && end > start) {
    return trimmed.substring(start, end + 1)
  }
  
  return trimmed
}

// 解析結果をパース
function parseAnalysisPayload(jsonString: string): AnalysisPayload {
  try {
    const json = JSON.parse(jsonString)
    
    // 日本語キーにも対応
    const emotion = json.emotion || json['感情カテゴリー']
    const title = json.title || json['タイトル']
    const summary = json.summary || json['要約']
    const advice = json.advice || json['アドバイス']
    
    if (!emotion || !title || !summary || !advice) {
      throw new Error('必要なフィールドが不足しています')
    }
    
    return {
      emotion: String(emotion),
      title: String(title),
      summary: String(summary),
      advice: String(advice)
    }
  } catch (error) {
    console.error('JSON parsing error:', error)
    throw new Error('解析結果の読み取りに失敗しました')
  }
}

serve(async (req) => {
  // CORS preflight リクエストの処理
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Supabaseクライアントの作成
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    // リクエストの処理
    if (req.method === 'POST') {
      const contentType = req.headers.get('content-type') || ''
      
      // 音声ファイルのアップロード処理
      if (contentType.includes('multipart/form-data')) {
        const formData = await req.formData()
        const audioFile = formData.get('file') as File
        
        if (!audioFile) {
          return new Response(
            JSON.stringify({ error: '音声ファイルが提供されていません' }),
            {
              headers: { ...corsHeaders, 'Content-Type': 'application/json' },
              status: 400,
            }
          )
        }

        // 音声をテキストに変換
        const transcript = await transcribeAudio(audioFile)
        
        // 感情分析を実行
        const analysis = await analyzeEmotion(transcript)

        return new Response(
          JSON.stringify({
            transcript,
            analysis,
          }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 200,
          }
        )
      }
      
      // JSONリクエスト（テキストから感情分析のみ）
      const body = await req.json()
      if (body.transcript) {
        const analysis = await analyzeEmotion(body.transcript)
        return new Response(
          JSON.stringify({ analysis }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 200,
          }
        )
      }

      // POSTリクエストだが、適切な形式でない場合
      return new Response(
        JSON.stringify({ 
          error: '無効なリクエストです。音声ファイル（multipart/form-data）またはtranscriptを含むJSONを送信してください。' 
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400,
        }
      )
    }

    // POST以外のメソッド（GET、PUT、DELETEなど）
    return new Response(
      JSON.stringify({ 
        error: `メソッド ${req.method} はサポートされていません。POSTメソッドを使用してください。` 
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 405, // Method Not Allowed
      }
    )
  } catch (error) {
    console.error('Error:', error)
    return new Response(
      JSON.stringify({ 
        error: error instanceof Error ? error.message : '予期しないエラーが発生しました'
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})
