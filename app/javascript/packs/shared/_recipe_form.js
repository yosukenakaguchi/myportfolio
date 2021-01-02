$("recipe_image").bind("change", function() {
  var size_in_megabytes = this.files[0].size/1024/1024;
  if (size_in_megabytes > 5) {
    alert("Maximum file size is 5MB. Please choose a smaller file.");
    $("#recipe_image").val("");
  }
});

$(function(){
    $("#input-text").on("keyup", function() {
      let countNum = String($(this).val().length);
      $("#counter").text(countNum + "/255words");
    });
    $('form').on('click', '.add_fields', function(event) {
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $(this).before($(this).data('fields').replace(regexp, time));
      return event.preventDefault();
    });
    $('form').on('click', '.remove_field', function(event) {
      $(this).prev('input[name*=_destroy]').val('true');
      $(this).closest('div.fields').hide();
      return event.preventDefault();
    });
  });

// $(function add_fields(link, association, content) {
//     var new_id = new Date().getTime();
//     var regexp = new RegExp("new_" + association, "g");
//     $(link).parent().before(content.replace(regexp, new_id));
// });
