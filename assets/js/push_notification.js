let pushNotification = {
    mounted() {
        console.log('aef');
        this.handleEvent("new_message", ({sender_name, message_string}) => 
            new Notification(
                sender_name,
                {body: message_string}
            )
        );
    },
};

export default pushNotification;