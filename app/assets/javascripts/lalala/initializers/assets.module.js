var MultipleFilesUploader = require("lalala/modules/multiple-files-uploader");
var SingleFileUploader = require("lalala/modules/single-file-uploader");


exports.init = function() {
  $("x-files[multiple-files]").each(function() {
    new MultipleFilesUploader(this);
  });

  $("x-files[single-file]").each(function() {
    new SingleFileUploader(this);
  });
};
