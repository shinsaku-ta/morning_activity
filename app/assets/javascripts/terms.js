$(function(){
  // 初期状態のボタンは無効
  $("#next-button").prop("disabled", true);
    // チェックボックスの状態が変わったら（クリックされたら）
    $("input[type='checkbox']").on('change', function () {
        // チェックされているチェックボックスの数
        if ($("#checkbox:checked").length > 0) {
          // ボタン有効
          $("#next-button").prop("disabled", false);
        } else {
          // ボタン無効
          $("#next-button").prop("disabled", true);
        }
    });
});
