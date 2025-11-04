// ゲーム状態の定義
let board = [];
let currentPlayer = 1; // 1: 黒, 2: 白
let isGameOver = false;

// 8方向の定義 (上、下、左、右、斜め4方向)
const directions = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1],           [0, 1],
    [1, -1],  [1, 0],  [1, 1]
];

// DOM要素の取得
const boardElement = document.getElementById('board');
const messageElement = document.getElementById('message');
const blackScoreElement = document.getElementById('black-score');
const whiteScoreElement = document.getElementById('white-score');
const resetBtn = document.getElementById('reset-btn');
const gameOverElement = document.getElementById('game-over');
const winnerMessageElement = document.getElementById('winner-message');
const finalScoreElement = document.getElementById('final-score');
const newGameBtn = document.getElementById('new-game-btn');

/**
 * ゲームの初期化
 */
function initGame() {
    // ボードの初期化（8x8の配列）
    board = Array(8).fill(null).map(() => Array(8).fill(0));
    
    // 初期配置（中央に4つの石を配置）
    board[3][3] = 2; // 白
    board[3][4] = 1; // 黒
    board[4][3] = 1; // 黒
    board[4][4] = 2; // 白
    
    currentPlayer = 1; // 黒から開始
    isGameOver = false;
    
    createBoard();
    updateUI();
}

/**
 * ボードのDOM要素を作成
 */
function createBoard() {
    boardElement.innerHTML = '';
    
    for (let row = 0; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            const cell = document.createElement('div');
            cell.className = 'cell';
            cell.dataset.row = row;
            cell.dataset.col = col;
            cell.addEventListener('click', () => cellClicked(row, col));
            boardElement.appendChild(cell);
        }
    }
}

/**
 * セルがクリックされた時の処理
 */
function cellClicked(row, col) {
    if (isGameOver) return;
    
    if (isValidMove(row, col, currentPlayer)) {
        placeStone(row, col, currentPlayer);
        
        // ターン交代
        currentPlayer = currentPlayer === 1 ? 2 : 1;
        
        // 次のプレイヤーが石を置ける場所があるかチェック
        const possibleMoves = getPossibleMoves(currentPlayer);
        
        if (possibleMoves.length === 0) {
            // 石を置ける場所がない場合、ターンをスキップ
            currentPlayer = currentPlayer === 1 ? 2 : 1;
            const nextPossibleMoves = getPossibleMoves(currentPlayer);
            
            if (nextPossibleMoves.length === 0) {
                // 両プレイヤーとも置けない場合、ゲーム終了
                endGame();
                return;
            } else {
                // スキップメッセージを表示
                showSkipMessage();
            }
        }
        
        updateUI();
        
        // ボードが満杯かチェック
        if (isBoardFull()) {
            endGame();
        }
    }
}

/**
 * 指定位置に石を置く
 */
function placeStone(row, col, player) {
    board[row][col] = player;
    flipStones(row, col, player);
}

/**
 * 指定位置に石を置けるかどうかを判定
 */
function isValidMove(row, col, player) {
    // セルが空でない場合は置けない
    if (board[row][col] !== 0) return false;
    
    const opponent = player === 1 ? 2 : 1;
    
    // 8方向をチェック
    for (const [dx, dy] of directions) {
        let x = row + dx;
        let y = col + dy;
        let hasOpponent = false;
        
        // 相手の石が続く限りチェック
        while (x >= 0 && x < 8 && y >= 0 && y < 8 && board[x][y] === opponent) {
            hasOpponent = true;
            x += dx;
            y += dy;
        }
        
        // 相手の石を挟んで自分の石がある場合、有効な手
        if (hasOpponent && x >= 0 && x < 8 && y >= 0 && y < 8 && board[x][y] === player) {
            return true;
        }
    }
    
    return false;
}

/**
 * 石を反転させる
 */
function flipStones(row, col, player) {
    const opponent = player === 1 ? 2 : 1;
    const toFlip = [];
    
    // 8方向をチェック
    for (const [dx, dy] of directions) {
        let x = row + dx;
        let y = col + dy;
        const tempFlip = [];
        
        // 相手の石が続く限り記録
        while (x >= 0 && x < 8 && y >= 0 && y < 8 && board[x][y] === opponent) {
            tempFlip.push([x, y]);
            x += dx;
            y += dy;
        }
        
        // 自分の石で挟めた場合、反転リストに追加
        if (tempFlip.length > 0 && x >= 0 && x < 8 && y >= 0 && y < 8 && board[x][y] === player) {
            toFlip.push(...tempFlip);
        }
    }
    
    // 反転を実行
    for (const [x, y] of toFlip) {
        board[x][y] = player;
    }
}

/**
 * プレイヤーが石を置ける場所のリストを取得
 */
function getPossibleMoves(player) {
    const moves = [];
    
    for (let row = 0; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            if (isValidMove(row, col, player)) {
                moves.push([row, col]);
            }
        }
    }
    
    return moves;
}

/**
 * ボードが満杯かチェック
 */
function isBoardFull() {
    for (let row = 0; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            if (board[row][col] === 0) return false;
        }
    }
    return true;
}

/**
 * 石の数をカウント
 */
function countStones() {
    let black = 0;
    let white = 0;
    
    for (let row = 0; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            if (board[row][col] === 1) black++;
            else if (board[row][col] === 2) white++;
        }
    }
    
    return { black, white };
}

/**
 * UIを更新
 */
function updateUI() {
    // ボードの更新
    const cells = boardElement.querySelectorAll('.cell');
    const possibleMoves = getPossibleMoves(currentPlayer);
    
    cells.forEach((cell, index) => {
        const row = Math.floor(index / 8);
        const col = index % 8;
        const value = board[row][col];
        
        // 既存の石をクリア
        cell.innerHTML = '';
        cell.classList.remove('has-stone', 'valid-move');
        
        // 石を配置
        if (value !== 0) {
            const stone = document.createElement('div');
            stone.className = `cell-stone ${value === 1 ? 'black' : 'white'}`;
            cell.appendChild(stone);
            cell.classList.add('has-stone');
        }
        
        // 置ける場所をハイライト
        if (possibleMoves.some(([r, c]) => r === row && c === col)) {
            cell.classList.add('valid-move');
        }
    });
    
    // スコアの更新
    const { black, white } = countStones();
    blackScoreElement.textContent = black;
    whiteScoreElement.textContent = white;
    
    // メッセージの更新
    if (!isGameOver) {
        messageElement.textContent = currentPlayer === 1 ? '黒の番です' : '白の番です';
    }
}

/**
 * スキップメッセージを表示
 */
function showSkipMessage() {
    const skipPlayer = currentPlayer === 1 ? '白' : '黒';
    messageElement.textContent = `${skipPlayer}は置ける場所がないのでスキップされました`;
    
    setTimeout(() => {
        updateUI();
    }, 1500);
}

/**
 * ゲーム終了処理
 */
function endGame() {
    isGameOver = true;
    const { black, white } = countStones();
    
    let winnerText = '';
    if (black > white) {
        winnerText = '黒の勝ち！';
    } else if (white > black) {
        winnerText = '白の勝ち！';
    } else {
        winnerText = '引き分け！';
    }
    
    winnerMessageElement.textContent = winnerText;
    finalScoreElement.textContent = `黒: ${black} - 白: ${white}`;
    gameOverElement.classList.remove('hidden');
}

/**
 * ゲームをリセット
 */
function resetGame() {
    gameOverElement.classList.add('hidden');
    initGame();
}

// イベントリスナーの設定
resetBtn.addEventListener('click', resetGame);
newGameBtn.addEventListener('click', resetGame);

// ゲームの開始
initGame();
