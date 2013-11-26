var FileUploader = require("lalala/modules/file-uploader");


exports.init = function() {
  $("x-files").each(function() {
    new FileUploader(this);
  });
};
