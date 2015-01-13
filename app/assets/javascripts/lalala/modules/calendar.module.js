var Calendar;


exports.init = function() {
  var instances = [];
  this.$el = $(".input.datetime_select, .input.date_select");
  this.$el.each(function() { instances.push(new Calendar(this)); });
};


Calendar = (function() {

  function Cal(input_element) {
    this.date_format = "DD-MM-YYYY HH:mm";

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
        self.set_date_on_hidden_fields(date, this.getTimeString());
      },
      showTime: true
    });

    cal.setDate(date);

    this.$el.data("calendar", cal);
  };


  Cal.prototype.get_date_from_hidden_fields = function() {
    var fields = [], values = [], new_date;

    this.$fieldset.find('input[type="hidden"]').each(function() {
      var name = $(this).attr("name");
      fields.push(name);
    });

    fields = fields.sort();
    new_date = new Date();

    for (var i=0,j=fields.length; i<j; ++i) {
      var value = this.$fieldset.find('input[name="' + fields[i] + '"]').val();
      var date_part_id = fields[i].match(/\(([^\)]+)\)/)[1];

      if (!value) {
        switch (date_part_id) {
          case "1i": value = new_date.getFullYear(); break;
          case "2i": value = new_date.getMonth() + 1; break;
          case "3i": value = new_date.getDate(); break;
          case "4i": value = "12"; break;
          case "5i": value = "00"; break;
        }
      }

      values.push(value);
    }

    // return js date
    return new Date(values[0], values[1] - 1, values[2], values[3], values[4]);
  };


  Cal.prototype.set_date_on_hidden_fields = function(date, time) {
    var day, month, year, hour, minute, $hidden_fields;

    day = date.getDate();
    month = date.getMonth() + 1;
    year = date.getFullYear();

    time_array = time.split(':');
    hour = time_array[0];
    minute = time_array[1];

    $hidden_fields = this.$fieldset.find('input[type="hidden"]');
    $hidden_fields.filter('[name$="(1i)]"]').val(year);
    $hidden_fields.filter('[name$="(2i)]"]').val(month);
    $hidden_fields.filter('[name$="(3i)]"]').val(day);
    $hidden_fields.filter('[name$="(4i)]"]').val(hour);
    $hidden_fields.filter('[name$="(5i)]"]').val(minute);
  };


  return Cal;

})();
