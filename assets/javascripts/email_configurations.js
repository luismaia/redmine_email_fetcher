$(function () {
    "use strict";

    function show_imap_fields() {
        document.getElementById('imap_email_only').style.display = 'block';

        // Fields specific actions
        document.getElementById("email_configuration_folder").disabled = false;

        // Set default values (if empty)
        if (document.getElementById('email_configuration_port').value == '') {
            document.getElementById('email_configuration_port').value = '993';
        }
    }

    function show_pop3_fields() {
        document.getElementById('pop3_email_only').style.display = 'block';

        // Fields specific actions
        document.getElementById("email_configuration_folder").disabled = true;

        // Set default values (if empty)
        if (document.getElementById('email_configuration_port').value == '') {
            document.getElementById('email_configuration_port').value = '995';
        }
        if (document.getElementById('email_configuration_folder').value == '') {
            document.getElementById('email_configuration_folder').value = 'INBOX';
        }
    }

    function hide_email_attrs_form() {
        document.getElementById('email_server_attrs').style.display = 'none';
        document.getElementById('redmine_email_new_sender_actions').style.display = 'none';
        document.getElementById('redmine_email_new_issue_attribures').style.display = 'none';

        document.getElementById('save_cancel_btn').style.display = 'none';
        document.getElementById('cancel_btn').style.display = 'block';

    }

    function show_email_attrs_form(email_config_type) {

        document.getElementById('email_server_attrs').style.display = 'block';
        document.getElementById('redmine_email_new_sender_actions').style.display = 'block';
        document.getElementById('redmine_email_new_sender_actions').style.display = 'block';
        document.getElementById('redmine_email_new_issue_attribures').style.display = 'block';

        document.getElementById('save_cancel_btn').style.display = 'block';
        document.getElementById('cancel_btn').style.display = 'none';

        document.getElementById('imap_email_only').style.display = 'none';
        document.getElementById('pop3_email_only').style.display = 'none';

        if (email_config_type == 'imap') {
            show_imap_fields();
        } else if (email_config_type == 'pop3') {
            show_pop3_fields();
        } else {
            hide_email_attrs_form();
        }
    }


    jQuery('#email_configuration_type').change(function () {
        var email_configuration_type = $('#email_configuration_type').val();
        show_email_attrs_form(email_configuration_type);
    });

});
