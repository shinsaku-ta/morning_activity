//カレンダー押下時処理
$(document).ready(function(){
  user_id = JSON.parse(document.getElementById('calendar').dataset.json);
  // cosole.log('test0');
  $('#calendar').fullCalendar({
    dayClick: function(date, jsEvent, view) {
      //クリックした日にちを保持しておく
      var $click_object = $(this);

      var now_datetime = new Date();
      var now_hour = now_datetime.getHours();
      var today_YMD = changeDateToYMD(now_datetime);

      var calendar_year_month = $(".fc-left h2").text();
      var start_str = calendarStrToYMD(calendar_year_month);
      var start_date = new Date(start_str);
      var add_start_date = addMonths(start_date, +1);
      var end_date = new Date(add_start_date.getFullYear(), add_start_date.getMonth(), add_start_date.getDate() - 1);
      var end_str = changeDateToYMD(end_date);
      //現在・未来時処理
      if (clickPossibleBoolean(date, now_datetime, today_YMD, now_hour, start_str, end_str)){
        createOrDestroyDate(user_id, date, $click_object, today_YMD);
      }
    }
  });

  console.log('check');
  //カレンダー表示時に日付の色設定
  dateColor();

  //今日の日付を確認し、12時以前かつstate0の場合のみ活性化
  // buttonActivity();
  //前←ボタンを押した時のイベント
  $('.fc-prev-button').click(function(){
    //カレンダーの日付の色設定
    dateColor();
  });

  //次→ボタンを押した時のイベント
  $('.fc-next-button').click(function(){
    //カレンダーの日付の色設定
    dateColor();
  });
});

//カレンダーの日付をクリックできるか判定
//下記の場合クリックが可能
//1.日付が未来である場合
//2.日付が現在でかつ12時以前である場合
//3. 1もしくは2と合わせて、表示年月と同じ日付の場合
//例）2020年 1月であれば、1月の1日〜31日までがクリック可能
function clickPossibleBoolean(date, now_datetime, today_YMD, now_hour, start_str, end_str){
  if ((date > now_datetime || (date.format() == today_YMD && now_hour <= 11)) && (start_str <= date.format() && end_str >= date.format())){
    return true
  }
  return false
}

//カレンダーの表示年月の範囲で、登録されている日付に色をつける
function dateColor(){
  var calendar_year_month = $(".fc-left h2").text();
  YMD_str = calendarStrToYMD(calendar_year_month);
  changeDateColor(user_id, YMD_str);
}

// function buttonActivity(){
//   var now_datetime = new Date();
//   var now_hour = now_datetime.getHours();
//   var today_YMD = changeDateToYMD(now_datetime);
//   console.log($(`.fc-bg td[data-date = '${today_YMD}']`).style.background);
// }

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
function changeDateToYMD(datetime){
  var day = toDoubleDigits(datetime.getDate());
  var month = toDoubleDigits(datetime.getMonth() + 1);
  var year = datetime.getFullYear();
  return year + '-' + month + '-' + day
}

//カレンダーの年月(文字列)から、年月+日(01)(文字列)を返す
function calendarStrToYMD(calendar_year_month){
  var year_position = calendar_year_month.indexOf('年');
  var month_position = calendar_year_month.indexOf('月');
  var year = calendar_year_month.slice(0, year_position);
  var month = toDoubleDigits(calendar_year_month.slice(year_position + 2, month_position));
  return year + '-' + month + '-01';
}

//カレンダーのクリックした日付がDBに登録しているか確認する。
//登録されていればDestroy処理、登録されていなければCreate処理を行う
//時間があれば、Destroy処理の関数とCreate処理の関数を作る
function createOrDestroyDate(user_id, date, $click_object, today_YMD){
  $.ajax({
    url: '/check_date',
    type: 'GET',
    data: {
      click_day : date.format()
    },
    dataType: 'json'
  })
  .done(function (data) {
      if(data.length){
        $.ajax({
          url: '/morning_actives/'+user_id,
          type: 'POST',
          data: {
            click_day : date.format(),
            '_method': 'DELETE'
          },
          dataType: 'json'
        })
        .done(function (data) {
          if(date.format() == today_YMD){
            $click_object.css('background-color', '#fcf8e3');
          }else{
            $click_object.css('background-color', 'transparent');
          }
        })
      }else{
        $.ajax({
          url: '/morning_actives/',
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
  })
}

//カレンダーに登録されている日付の色付け処理
//朝活成功：水色
//朝活失敗：赤色
//朝活予定日：緑色
function changeDateColor(user_id, YMD_str){
  $.ajax({
    url: '/morning_actives/'+user_id,
    type: 'GET',
    data: {
      month : YMD_str
    },
    dataType: 'json'
  })
  .done(function (data) {
    for ( var i = 0; i < data[0].month.length; i++ ){
      // var date = new Date(data[i].execution_at);
      var date = new Date(data[0].month[i].execution_at);
      var yyyy_MM_dd = changeDateToYMD(date);
      if(data[0].month[i].state == 'not_implemented'){
        $(`.fc-bg td[data-date = '${yyyy_MM_dd}']`).css('background-color', 'rgb(102, 204, 102)');
      }else if(data[0].month[i].state == 'success'){
        $(`.fc-bg td[data-date = '${yyyy_MM_dd}']`).css('background-color', 'rgb(0, 172, 238)');
      }else{
        $(`.fc-bg td[data-date = '${yyyy_MM_dd}']`).css('background-color', 'rgb(255, 102, 102)');
      }
    }

    //ボタン活性・非活性設定
    if(data[0].day.length > 0){
      $("#js-activity-button").prop("disabled", false);
    }else{
      $("#js-activity-button").prop("disabled", true);
    }
  })
}
