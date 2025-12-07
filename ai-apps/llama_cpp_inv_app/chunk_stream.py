from llama_cpp import Llama

llm = Llama(
    model_path="/Users/yoshiki.takamatsu/Library/Caches/llama.cpp/ggml-org_gemma-3-1b-it-GGUF_gemma-3-1b-it-Q4_K_M.gguf",
    n_ctx=4096,
    n_threads=6,
    verbose=False
)

stream = llm(
    "ストリーミング出力のテストをします。",
    max_tokens=200,
    stream=True
)

for chunk in stream:
    token = chunk["choices"][0]["text"]
    print(token, end="", flush=True)