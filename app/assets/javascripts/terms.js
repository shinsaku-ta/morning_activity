//チェックボックスの有無でボタンの活性・非活性を分ける
$(function() {
  // 初期状態のボタンは無効
  $("#next-button").prop("disabled", true);
  // チェックボックスがクリック(アンクリック)されたら
  $("input[type='checkbox']").on('change', function () {
    // チェックされているチェックボックスの数で判定
    if ($("#checkbox:checked").length > 0) {
      // 1個以上であればボタン有効
      $("#next-button").prop("disabled", false);
    } else {
      // 0個であればボタン無効
      $("#next-button").prop("disabled", true);
    }
  });
});
