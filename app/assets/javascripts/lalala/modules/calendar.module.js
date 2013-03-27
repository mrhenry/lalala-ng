var Calendar;


exports.init = function() {
  var instances = [];
  this.$el = $(".input.datetime_select, .input.date_select");
  this.$el.each(function() { instances.push(new Calendar(this)); });
};


Calendar = (function() {

  function Cal(input_element) {
    this.date_format = "DD-MM-YYYY";

    this.$el = $(input_element);
    this.$fieldset = this.$el.children(".fragments");

    this.replace_select_fields_with_hidden_fields();
    this.create_new_input_field();
    this.setup_pikaday_instance();
  }


  Cal.prototype.replace_select_fields_with_hidden_fields = function() {
    var $select = this.$fieldset.find(".fragments-group select"),
        _this = this;

    $select.each(function() {
      var new_input_field, checked_value;

      checked_value = $(this).find("option:checked").val();
      new_input_field = document.createElement("input");
      new_input_field.setAttribute("type", "hidden");
      new_input_field.setAttribute("name", this.name);
      new_input_field.setAttribute("value", checked_value);

      _this.$fieldset.append(new_input_field);
    });

    $select.closest(".fragments-group").remove();
  };


  Cal.prototype.create_new_input_field = function() {
    var new_input_field, date, date_string;

    date = this.get_date_from_hidden_fields();
    date_string = moment(date).format(this.date_format);

    new_input_field = document.createElement("input");
    new_input_field.setAttribute("type", "text");
    new_input_field.setAttribute("class", "calendar-input-field");
    new_input_field.value = date_string;

    this.$fieldset.append(new_input_field);
  };


  Cal.prototype.setup_pikaday_instance = function() {
    var cal, new_input, self = this;

    new_input = this.$el.find("input.calendar-input-field")[0];
    date = this.get_date_from_hidden_fields();

    cal = new Pikaday({
      format: this.date_format,
      defaultDate: date,
      field: new_input,
      firstDay: 1,
      onSelect: function(date) {
        self.set_date_on_hidden_fields(date);
      }
    });

    this.$el.data("calendar", cal);
  };


  Cal.prototype.get_date_from_hidden_fields = function() {
    var values = [];

    this.$fieldset.find('input[type="hidden"]').each(function() {
      values.push( $(this).val() );
    });

    // return js date
    return new Date(values[0], values[1] - 1, values[2]);
  };


  Cal.prototype.set_date_on_hidden_fields = function(date) {
    var day, month, year, $hidden_fields;

    day = date.getDate();
    month = date.getMonth() + 1;
    year = date.getFullYear();

    $hidden_fields = this.$fieldset.find('input[type="hidden"]');
    $hidden_fields.filter('[name$="(1i)]"]').val(year);
    $hidden_fields.filter('[name$="(2i)]"]').val(month);
    $hidden_fields.filter('[name$="(3i)]"]').val(day);
    $hidden_fields.filter('[name$="(4i)]"]').val("00");
    $hidden_fields.filter('[name$="(5i)]"]').val("00");
  };


  return Cal;

})();
