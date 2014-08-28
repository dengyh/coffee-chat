$(function() {
    var flag = true;
    var socket = io();

    $('#my-modal').modal('show');
    $('.chat-box').children('p').show();

    $('#my-modal').on('hide.bs.modal', function(event) {
        if (flag) {
            return false;
        }
    });

    $('#my-modal').on('hidden.bs.modal', function(event) {
        $('.chat-box').fadeIn(1000, function() {
            $('.chat-input').fadeIn(1000);
        });
    });

    $('#come-back').click(function() {
        var name = $('#last-name').html();
        socket.emit('newUser', name);
        flag = false;
        $('#my-modal').modal('hide');
    });

    $('#confirm').click(function() {
        $('#my-modal').modal('show');
    });

    $('#name-form').submit(function() {
        var name = $(this).find('[name="name"]').val();
        if (name == '') {
            $('.wrong').fadeOut(500, function() {
                $(this).html('The input is null').fadeIn(1000);
            });
            return false;
        }
        $.post('/user', {
            'name': name
        }, function(data) {
            if (data['success']) {
                socket.emit('newUser', name);
                flag = false;
                $('#my-modal').modal('hide');
            } else {
                $('.wrong').fadeOut(500, function() {
                    $(this).html('Your name had been used').fadeIn(1000);
                });
            }
        }, 'json');
        return false;
    });

    $('#message-form').submit(function() {
        var content = $(this).find('[name="content"]').val();
        var user_id = $(this).find('[name="user_id"]').val();
        var username = $(this).find('[name="username"]').val();
        if (content == '') {
            return false;
        }
        $.post('/message', {
            'content': content,
            'user_id': user_id
        }, function(data) {
            if (data['success']) {
                $('#message-form').find('[name="content"]').val('');
                socket.emit('chat', content, username, user_id, data['time']);
            }
        }, 'json');
        return false;
    });

    socket.on('chat', function(content, username, user_id, time) {
        $('.chat-box').append('<p><a href="/user/home/' + user_id + '"><span class="username">' +
            username + '</span></a> : ' + content + '<p class="time">—— ' +
            getFormatTime(time) + '</p></p>');
        $('.chat-box').children('p').fadeIn(500);
    });

    socket.on('newUser', function(username) {
        $('.chat-box').append('<p class="new-user"><span class="username">' + username +
            '</span> come into chat room</p>');
        $('.chat-box').children('p').fadeIn(500);
    });

    function getFormatTime(time) {
        var tempTime = new Date(time);
        var result = '';
        result += tempTime.getFullYear() + '-';
        result += (tempTime.getMonth() + 1) + '-';
        result += tempTime.getDate() + ' ';
        result += tempTime.getHours() + ':';
        result += tempTime.getMinutes() + ':';
        result += tempTime.getSeconds();
        return result;
    }
});