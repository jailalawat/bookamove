$(document).ready(function () {

    $('.ok-user-profile').on('click', function (event) {
        var pass = $('.password-user-profile');
        var pass_conf = $('.password-conf-user-profile');
        if (pass.val() != pass_conf.val()) {
            $(".msg-error-pass").removeClass("hidden");
            $(".msg-error-pass").fadeTo(2000, 500).slideUp(500, function () {
                $(".msg-error-pass").addClass("hidden");
            })
            event.preventDefault();
        }
    });

    $('.remove_image_toggle').on('click', function () {
        $('.user_profile_toggle').toggle("slow");
    });

    delete_image();
    var dropbox = $('#dropbox-user-profile'),
        message = $('.dropbox-user-profile', dropbox);
    var path = window.location.pathname;
    var url = 'upload_files/new.json';
    var edit_user = dropbox.data('user');
    if (path == "/accounts") {
        url = '/accounts/upload_files/new.json'
    }
    if (edit_user) {
        url = '/upload_files/new.json?id=' + edit_user;
    }
    dropbox.filedrop({
        // The name of the $_FILES entry:
        paramname: 'upload[file]',
        maxfiles: 5,
        maxfilesize: 1,
        url: url,

        uploadFinished: function (i, file, response) {
            var image_default = $('[data-type*="image-default"]');
            if (typeof image_default != 'undefined') {
                $('.carousel.graph').carousel({
                    pause: false,
                    interval: 1000
                }).carousel(0);
                $('[data-type*="image-default"]').remove();
            }
            $('.carousel-inner .item_user_profile').removeClass('active');
            $('.carousel-inner').append('<div data-image-id=' + response.id + ' class="item item_user_profile active"><img src="' + response.file + '"></div>');
            var count = $('.carousel-indicators li:last').data('slide-to');
            $('.carousel-indicators li').removeClass('active');
            $('.carousel-indicators').append('<li data-image-id=' + response.id + ' data-slide-to="' + (typeof count == 'undefined' ? 0 : count + 1 ) + '" data-target="#carousel_user_profile" class="active"></li>');
            $('#carousel_user_profile').carousel(typeof count == 'undefined' ? 0 : count + 1);
            $('.user_profile_toggle').append('<div data-image-id=' + response.id + ' class="item item_user_profile col-md-3"><div class="profile_image_delete_div delete-image-' + response.id + '" data-image-id=' + response.id + '><img alt="X" class="profile_image_delete_button" src="/assets/x.png"></div><img class="img_responsive_user_profile" src=' + response.file + '></div>');
            delete_image($(".delete-image-" + response.id));
            $('.carousel-control').removeClass('hide');
        },

        error: function (err, file) {
            switch (err) {
                case 'BrowserNotSupported':
                    showMessage('Your browser does not support HTML5 file uploads!');
                    break;
                case 'TooManyFiles':
                    alert('Too many files! Please select 5 at most! (configurable)');
                    break;
                case 'FileTooLarge':
                    alert(file.name + ' is too large! Please upload files up to 1mb.');
                    break;
                default:
                    error_permissions();
                    break;
            }
        },

        // Called before each upload is started
        beforeEach: function (file) {
            if (!file.type.match(/^image\//)) {
                alert('Only images are allowed!');

                // Returning false will cause the
                // file to be rejected
                return false;
            }
        }
    });

    function showMessage(msg) {
        message.html(msg);
    }
});


(function ($) {

    jQuery.event.props.push("dataTransfer");
    var opts = {},
        default_opts = {
            url: '',
            refresh: 1000,
            paramname: 'userfile',
            maxfiles: 25,
            maxfilesize: 1, // MBs
            data: {},
            drop: empty,
            dragEnter: empty,
            dragOver: empty,
            dragLeave: empty,
            docEnter: empty,
            docOver: empty,
            docLeave: empty,
            beforeEach: empty,
            afterAll: empty,
            rename: empty,
            error: function (err, file, i) {
                alert(err);
            },
            uploadStarted: empty,
            uploadFinished: empty,
            progressUpdated: empty,
            speedUpdated: empty
        },
        errors = ["BrowserNotSupported", "TooManyFiles", "FileTooLarge"],
        doc_leave_timer,
        stop_loop = false,
        files_count = 0,
        files;

    $.fn.filedrop = function (options) {
        opts = $.extend({}, default_opts, options);

        this.bind('drop', drop).bind('dragenter', dragEnter).bind('dragover', dragOver).bind('dragleave', dragLeave);
        $(document).bind('drop', docDrop).bind('dragenter', docEnter).bind('dragover', docOver).bind('dragleave', docLeave);
    };

    function drop(e) {
        opts.drop(e);
        files = e.dataTransfer.files;
        if (files === null || files === undefined) {
            opts.error(errors[0]);
            return false;
        }

        files_count = files.length;
        upload();
        e.preventDefault();
        return false;
    }

    function getBuilder(filename, filedata, boundary) {
        var dashdash = '--',
            crlf = '\r\n',
            builder = '';

        $.each(opts.data, function (i, val) {
            if (typeof val === 'function') val = val();
            builder += dashdash;
            builder += boundary;
            builder += crlf;
            builder += 'Content-Disposition: form-data; name="' + i + '"';
            builder += crlf;
            builder += crlf;
            builder += val;
            builder += crlf;
        });

        builder += dashdash;
        builder += boundary;
        builder += crlf;
        builder += 'Content-Disposition: form-data; name="' + opts.paramname + '"';
        builder += '; filename="' + filename + '"';
        builder += crlf;

        builder += 'Content-Type: application/octet-stream';
        builder += crlf;
        builder += crlf;

        builder += filedata;
        builder += crlf;

        builder += dashdash;
        builder += boundary;
        builder += dashdash;
        builder += crlf;
        return builder;
    }

    function progress(e) {
        if (e.lengthComputable) {
            var percentage = Math.round((e.loaded * 100) / e.total);
            if (this.currentProgress != percentage) {

                this.currentProgress = percentage;
                opts.progressUpdated(this.index, this.file, this.currentProgress);

                var elapsed = new Date().getTime();
                var diffTime = elapsed - this.currentStart;
                if (diffTime >= opts.refresh) {
                    var diffData = e.loaded - this.startData;
                    var speed = diffData / diffTime; // KB per second
                    opts.speedUpdated(this.index, this.file, speed);
                    this.startData = e.loaded;
                    this.currentStart = elapsed;
                }
            }
        }
    }


    function upload() {
        stop_loop = false;
        if (!files) {
            opts.error(errors[0]);
            error_permissions();
            return false;
        }
        var filesDone = 0,
            filesRejected = 0;

        if (files_count > opts.maxfiles) {
            opts.error(errors[1]);
            return false;
        }

        for (var i = 0; i < files_count; i++) {
            if (stop_loop) return false;
            try {
                if (beforeEach(files[i]) != false) {
                    if (i === files_count) return;
                    var reader = new FileReader(),
                        max_file_size = 1048576 * opts.maxfilesize;

                    reader.index = i;
                    if (files[i].size > max_file_size) {
                        opts.error(errors[2], files[i], i);
                        filesRejected++;
                        continue;
                    }
                    reader.onloadend = send;
                    reader.readAsBinaryString(files[i]);
                } else {
                    filesRejected++;
                    error_permissions();
                }
            } catch (err) {
                error_permissions();
                opts.error(errors[0]);
                return false;
            }
        }

        function send(e) {
            // Sometimes the index is not attached to the
            // event object. Find it by size. Hack for sure.
            if (e.target.index == undefined) {
                e.target.index = getIndexBySize(e.total);
            }

            var xhr = new XMLHttpRequest(),
                upload = xhr.upload,
                file = files[e.target.index],
                index = e.target.index,
                start_time = new Date().getTime(),
                boundary = '------multipartformboundary' + (new Date).getTime(),
                builder;

            newName = rename(file.name);
            if (typeof newName === "string") {
                builder = getBuilder(newName, e.target.result, boundary);
            } else {
                builder = getBuilder(file.name, e.target.result, boundary);
            }

            upload.index = index;
            upload.file = file;
            upload.downloadStartTime = start_time;
            upload.currentStart = start_time;
            upload.currentProgress = 0;
            upload.startData = 0;
            upload.addEventListener("progress", progress, false);

            xhr.open("POST", opts.url, true);
            xhr.setRequestHeader('content-type', 'multipart/form-data; boundary='
                + boundary);

            xhr.sendAsBinary(builder);

            opts.uploadStarted(index, file, files_count);

            xhr.onload = function () {
                if (xhr.responseText) {
                    var now = new Date().getTime(),
                        timeDiff = now - start_time,
                        result = opts.uploadFinished(index, file, jQuery.parseJSON(xhr.responseText), timeDiff);
                    filesDone++;
                    if (filesDone == files_count - filesRejected) {
                        afterAll();
                    }
                    if (result === false) {
                        error_permissions();
                        stop_loop = true;
                    }
                }
            };
        }
    }

    function getIndexBySize(size) {
        for (var i = 0; i < files_count; i++) {
            if (files[i].size == size) {
                return i;
            }
        }

        return undefined;
    }

    function rename(name) {
        return opts.rename(name);
    }

    function beforeEach(file) {
        return opts.beforeEach(file);
    }

    function afterAll() {
        return opts.afterAll();
    }

    function dragEnter(e) {
        clearTimeout(doc_leave_timer);
        e.preventDefault();
        opts.dragEnter(e);
    }

    function dragOver(e) {
        clearTimeout(doc_leave_timer);
        e.preventDefault();
        opts.docOver(e);
        opts.dragOver(e);
    }

    function dragLeave(e) {
        clearTimeout(doc_leave_timer);
        opts.dragLeave(e);
        e.stopPropagation();
    }

    function docDrop(e) {
        e.preventDefault();
        opts.docLeave(e);
        return false;
    }

    function docEnter(e) {
        clearTimeout(doc_leave_timer);
        e.preventDefault();
        opts.docEnter(e);
        return false;
    }

    function docOver(e) {
        clearTimeout(doc_leave_timer);
        e.preventDefault();
        opts.docOver(e);
        return false;
    }

    function docLeave(e) {
        doc_leave_timer = setTimeout(function () {
            opts.docLeave(e);
        }, 200);
    }

    function empty() {
    }

    try {
        if (XMLHttpRequest.prototype.sendAsBinary) return;
        XMLHttpRequest.prototype.sendAsBinary = function (datastr) {
            function byteValue(x) {
                return x.charCodeAt(0) & 0xff;
            }

            var ords = Array.prototype.map.call(datastr, byteValue);
            var ui8a = new Uint8Array(ords);
            this.send(ui8a.buffer);
        }
    } catch (e) {
        error_permissions();
    }

})(jQuery);

function delete_image(selector) {
    var selector = typeof selector == 'undefined' ? $('.profile_image_delete_div') : selector;
    selector.on('click', function () {
        var user_id = $(this).data('image-id');
        var path = window.location.pathname;
        var url = 'upload_files/destroy.json';
        if (path == "/accounts") {
            url = '/accounts/upload_files/destroy.json'
        }
        if ($('#dropbox-user-profile').data('user')) {
            url = '/upload_files/destroy.json';
        }
        $.ajax({
            url: url,
            type: 'DELETE',
            data: {img_ID: user_id}
        }).done(function () {
            var count = $('.carousel-indicators li').length;
            if (count == 1) {
                location.reload();
            }
            var validate = $('[data-image-id*="' + user_id + '"]').hasClass('active');
            var time = 0;
            if (validate) {
                $('[data-slide*="next"]').trigger('click');
                time = 1000;
            }
            setTimeout(function () {
                $('[data-image-id*="' + user_id + '"]').remove();
            }, time);

        }).fail(function (data) {
            error_permissions();
        });
    });
}