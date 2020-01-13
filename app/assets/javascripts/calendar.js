//カレンダー押下時処理
$(document).ready(function() {
  $('#calendar').fullCalendar({
    dayClick: function(selectableDate, jsEvent, view) {
      //クリックした日にちを保持しておく
      var $click_object = $(this);

      //現在・未来時処理
      if (clickableDate(selectableDate)) {
        createOrDestroyDate(selectableDate, $click_object);
      }
    }
  });

  //カレンダーの色設定
  dateColor();
  changeButtonDisabled();

  //前←ボタンを押した時のイベント
  $('.fc-prev-button').click(function() {
    //カレンダーの色設定
    dateColor();
    changeButtonDisabled();
  });

  //次→ボタンを押した時のイベント
  $('.fc-next-button').click(function() {
    //カレンダーの色設定
    dateColor();
    changeButtonDisabled();
  });
});

//カレンダーの日付をクリックできるか判定
function clickableDate(selectableDate) {
  //カレンダーの表示年月の範囲の場合
  //例）2020年 1月であれば、1月の1日〜31日までがクリック可能
  if(month_start_date() <= selectableDate.format() && month_end_date() >= selectableDate.format()) {
    //日付が未来である場合
    if(selectableDate > now_datetime()) {
      return true
    }

    //日付が現在でかつ12時以前である場合
    if(selectableDate.format() == now_date() && now_hour() < 12) {
      return true
    }
  }
  return false
}


//現在の日時datetime形式で取得
function now_datetime() {
  var now_datetime = new Date();
  return now_datetime
}

//現在の日付date形式で取得
function now_date() {
  var now_datetime = new Date();
  return changeDateToYMD(now_datetime);
}

//現在の時間のみを取得
function now_hour() {
  var now_datetime = new Date();
  return now_datetime.getHours();
}

//カレンダー年月から月初の日時を取得(yyyy_MM_dd形式)
function month_start_date() {
  var calendar_year_month = $(".fc-left h2").text();
  var start_str = calendarStrToYMD(calendar_year_month);
  return start_str
}

//カレンダー年月から月終の日時を取得(yyyy_MM_dd形式)
function month_end_date() {
  var start_str = month_start_date();
  var start_date = new Date(start_str);
  var add_start_date = addMonths(start_date, +1);
  var end_date = new Date(add_start_date.getFullYear(), add_start_date.getMonth(), add_start_date.getDate() - 1);
  var end_str = changeDateToYMD(end_date);
  return end_str;
}

//カレンダーの表示年月の範囲で、登録されている日付に色をつける
function dateColor() {
  var calendar_year_month = $(".fc-left h2").text();
  YMD_str = calendarStrToYMD(calendar_year_month);
  changeDateColor(YMD_str);
}

//Date型の月加算・減算
//使い方、dateに標準の時間を指定、monthsにプラスする月数を指定
function addMonths(date, months) {
    var resultDate = new Date(date.getTime());
    resultDate.setMonth(date.getMonth() + months);
    return resultDate;
}

//月・日の0埋め
//例 1→01
var toDoubleDigits = function(num) {
  num += "";
  if (num.length === 1) {
    num = "0" + num;
  }
 return num;
};

//Datetime型の日付から、String型の年月日を返す
function changeDateToYMD(datetime) {
  var day = toDoubleDigits(datetime.getDate());
  var month = toDoubleDigits(datetime.getMonth() + 1);
  var year = datetime.getFullYear();
  return year + '-' + month + '-' + day
}

//カレンダーの年月(文字列)から、年月+日(01)(文字列)を返す
function calendarStrToYMD(calendar_year_month) {
  var year_position = calendar_year_month.indexOf('年');
  var month_position = calendar_year_month.indexOf('月');
  var year = calendar_year_month.slice(0, year_position);
  var month = toDoubleDigits(calendar_year_month.slice(year_position + 2, month_position));
  return year + '-' + month + '-01';
}

//日付が登録されていればDestroy処理、登録されていなければCreate処理を行う
function createOrDestroyDate(date, $click_object) {
  $.ajax({
    url: '/morning_activity_results/'+date.format(),
    type: 'GET',
    dataType: 'json'
  })
  .done(function (data) {
    if(data == null){
      ajaxCreateDate(date, $click_object);
    }else{
      ajaxDeleteDate(date, $click_object);
    }
  })
}

//ajaxよりDBにアクセスし日付の削除を行う
function ajaxDeleteDate(date, $click_object) {
  $.ajax({
    url: '/morning_activity_results/'+date.format(),
    type: 'POST',
    data: {
      '_method': 'DELETE'
    },
    dataType: 'json'
  })
  .done(function (data) {
    if(date.format() == now_date()) {
      changeNowColor($click_object);
    } else {
      $click_object.css('background-color', 'transparent');
    }
  })
}

//ajaxよりDBにアクセスし日付の登録を行う
function ajaxCreateDate(date, $click_object) {
  $.ajax({
    url: '/morning_activity_results/',
    type: 'POST',
    data: {
      click_day : date.format()
    },
    dataType: 'json'
  })
  .done(function (data) {
    $click_object.css('background-color', 'rgb(102, 204, 102)');
  })
}

//カレンダーに登録されている日付の色付け処理
//朝活成功：水色
//朝活失敗：赤色
//朝活予定日：緑色
function changeDateColor(YMD_str) {
  $.ajax({
    url: '/morning_activity_results/',
    type: 'GET',
    data: {
      month : YMD_str
    },
    dataType: 'json'
  })
  .done(function (data) {
    for ( var i = 0; i < data.length; i++ ) {
      var date = new Date(data[i].execution_at);
      var yyyy_MM_dd = changeDateToYMD(date);
      if(data[i].state == 'not_implemented') {
        $(`.fc-bg td[data-date = '${yyyy_MM_dd}']`).css('background-color', 'rgb(102, 204, 102)');
      } else if(data[i].state == 'success') {
        $(`.fc-bg td[data-date = '${yyyy_MM_dd}']`).css('background-color', 'rgb(0, 172, 238)');
      } else {
        $(`.fc-bg td[data-date = '${yyyy_MM_dd}']`).css('background-color', 'rgb(255, 102, 102)');
      }
    }
  })
}

//今日のデータを取得
function ajaxTodayDate() {
  return result = $.ajax({
    url: '/today_morning_activity_result',
    type: 'GET',
    dataType: 'json'
  })
}

//朝活スタートボタンの活性・非活性
function changeButtonDisabled() {
  $('#js-activity-button').prop('disabled', true);
  ajaxTodayDate().done(function(data){
    if(data == null){
      return;
    }

    if(data.state == 'not_implemented'){
      $('#js-activity-button').prop('disabled', false);
    }
  });
}

//本日Delete例外処理対応
function changeNowColor($click_object){
  ajaxTodayDate().done(function(data){
    if(data == null){
      $click_object.css('background-color', 'rgb(252, 248, 227)');
    }
  });
}
