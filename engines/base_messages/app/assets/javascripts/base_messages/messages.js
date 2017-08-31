App.messages = App.cable.subscriptions.create('BaseMessages::MessagesChannel', {
  received: function(data) {
    // this will render all received messages from the MessagesChannel on the div id=messages
    $("#messages").removeClass('hidden');
    return $('#messages').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    return "<p>" + data.message + "</p>";
  }
});
