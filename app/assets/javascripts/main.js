$(function() {
  $(".upload input[type='file']").change(function() {
    $(this).parents("form").submit();
  });
});