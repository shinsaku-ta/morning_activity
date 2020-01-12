$(function() {
  //指定した画像をプレビュー表示
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        //プレビュー表示
        $('#js-picture-preview').attr('src', e.target.result);
      };
      reader.readAsDataURL(input.files[0]);
    }
  }
  //画像が変更された場合のイベント
  $('#js-post-picture').change(function(){
    readURL(this);
  });
});
