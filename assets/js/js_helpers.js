let jsHelpers = {
    mounted() {
      this.doJsActions();
    },
    updated() {
      this.doJsActions();
    },
    doJsActions() {
        console.log(this.el);
        // Pins the scroll to bottom
        const container = document.getElementById('message-scroller');
        container.scrollTop = container.scrollHeight;

        const inputField = document.getElementById('_msg_text');

        // Clear the input field by setting its value to an empty string
        inputField.value = '';

        // Set the focus on the input field
        inputField.focus();
    },
  };
  
  export default jsHelpers;
  