let pushNotification = {
    mounted() {
        Notification.requestPermission();

        this.handleEvent("new_message", ({sender_name, message_string}) => 
            {
                if (!document.hasFocus()) {
                    this.sendNotification(sender_name, message_string)
                }
            }
        );
    },
    sendNotification(sender_name, message_string) {
        let notification = 
            new Notification(
                sender_name,
                {
                    body: message_string,
                    // icon: 'https://static.toiimg.com/thumb/msid-100436479,width-1280,height-720,resizemode-4/.jpg'
                }
            )
    }
};

export default pushNotification;