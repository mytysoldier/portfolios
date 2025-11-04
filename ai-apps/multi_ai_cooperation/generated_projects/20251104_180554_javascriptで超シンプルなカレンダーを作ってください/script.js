// 現在の日付情報を保持
let currentDate = new Date();

// DOM要素の取得
const calendarDays = document.getElementById('calendarDays');
const currentMonthElement = document.getElementById('currentMonth');
const prevMonthButton = document.getElementById('prevMonth');
const nextMonthButton = document.getElementById('nextMonth');

/**
 * カレンダーを描画する関数
 */
function renderCalendar() {
    // 現在の年月を取得
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();
    
    // ヘッダーに年月を表示
    currentMonthElement.textContent = `${year}年 ${month + 1}月`;
    
    // 今日の日付情報
    const today = new Date();
    const isCurrentMonth = today.getFullYear() === year && today.getMonth() === month;
    const todayDate = today.getDate();
    
    // 月の最初の日と最後の日を取得
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    
    // 前月の最後の日を取得
    const prevLastDay = new Date(year, month, 0);
    
    // カレンダーの日付情報
    const firstDayOfWeek = firstDay.getDay(); // 月の最初の日の曜日（0:日曜〜6:土曜）
    const lastDate = lastDay.getDate(); // 月の最後の日付
    const prevLastDate = prevLastDay.getDate(); // 前月の最後の日付
    
    // カレンダーの日付をクリア
    calendarDays.innerHTML = '';
    
    // 前月の日付を表示（月の最初の日が日曜日でない場合）
    for (let i = firstDayOfWeek - 1; i >= 0; i--) {
        const day = createDayElement(prevLastDate - i, 'other-month', -1);
        calendarDays.appendChild(day);
    }
    
    // 当月の日付を表示
    for (let date = 1; date <= lastDate; date++) {
        const dayOfWeek = new Date(year, month, date).getDay();
        const isToday = isCurrentMonth && date === todayDate;
        const day = createDayElement(date, '', dayOfWeek, isToday);
        calendarDays.appendChild(day);
    }
    
    // 次月の日付を表示（カレンダーのグリッドを埋めるため）
    const totalCells = calendarDays.children.length;
    const remainingCells = totalCells % 7 === 0 ? 0 : 7 - (totalCells % 7);
    
    for (let date = 1; date <= remainingCells; date++) {
        const day = createDayElement(date, 'other-month', -1);
        calendarDays.appendChild(day);
    }
}

/**
 * 日付要素を作成する関数
 * @param {number} date - 日付
 * @param {string} className - 追加するクラス名
 * @param {number} dayOfWeek - 曜日（0:日曜〜6:土曜、-1:前後月）
 * @param {boolean} isToday - 今日かどうか
 * @returns {HTMLElement} 日付要素
 */
function createDayElement(date, className = '', dayOfWeek = -1, isToday = false) {
    const dayElement = document.createElement('div');
    dayElement.classList.add('day');
    
    if (className) {
        dayElement.classList.add(className);
    }
    
    // 今日の日付にクラスを追加
    if (isToday) {
        dayElement.classList.add('today');
    }
    
    // 日曜日と土曜日にクラスを追加
    if (dayOfWeek === 0 && !className) {
        dayElement.classList.add('sunday');
    } else if (dayOfWeek === 6 && !className) {
        dayElement.classList.add('saturday');
    }
    
    dayElement.textContent = date;
    
    // 日付クリック時のイベント（オプション機能）
    if (!className) {
        dayElement.addEventListener('click', () => {
            const year = currentDate.getFullYear();
            const month = currentDate.getMonth() + 1;
            alert(`${year}年${month}月${date}日がクリックされました`);
        });
    }
    
    return dayElement;
}

/**
 * 前月に移動する関数
 */
function goToPrevMonth() {
    currentDate.setMonth(currentDate.getMonth() - 1);
    renderCalendar();
}

/**
 * 次月に移動する関数
 */
function goToNextMonth() {
    currentDate.setMonth(currentDate.getMonth() + 1);
    renderCalendar();
}

// イベントリスナーの設定
prevMonthButton.addEventListener('click', goToPrevMonth);
nextMonthButton.addEventListener('click', goToNextMonth);

// キーボード操作のサポート（オプション）
document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowLeft') {
        goToPrevMonth();
    } else if (e.key === 'ArrowRight') {
        goToNextMonth();
    }
});

// 初期表示
renderCalendar();
