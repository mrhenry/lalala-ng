'use strict';


var lalala_storage;


// Get lalala storage object from local storage
try {
  lalala_storage = JSON.parse(localStorage.lalala);

} catch(error) {
  console.error(error);

}

// If lalala storage doesn't exist, create empty object
if (!lalala_storage) {
  lalala_storage = {};
}


/**
 * On window unload save lalala storage object to local storage
 */
$(window).unload(function(){
  console.log("storage save");
  localStorage.lalala = JSON.stringify(lalala_storage);
});


/**
 * @export {Object}
 */
module.exports = lalala_storage;
