var lalala_storage;

try {
  lalala_storage = JSON.parse(localStorage.lalala);
} catch(e) {}

if (!lalala_storage) {
  lalala_storage = {};
}

$(window).unload(function(){
  localStorage.lalala = JSON.stringify(lalala_storage);
});

module.exports = lalala_storage;
