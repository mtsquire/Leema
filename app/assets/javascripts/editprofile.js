/*$(document).ready(function(){


  function readURL(input) {

        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
              var tempPhoto = $('#preview-profile-photo');
                tempPhoto.attr('src', e.target.result);
                tempPhoto.Jcrop({
                  setSelect:   [ 400, 400, 50, 50 ],
                  aspectRatio: 1
                });
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#imgInp").change(function(){
        readURL(this);
    });
});
*/
