// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
//import * as ActiveStorage from "@rails/activestorage"
import "channels"
//require ('packs/baguetteBox.min')

let noticeCount = 0;
let isFirstPost = true;

document.onkeydown = (e) => {
  if (isPressedSubmitKey(e) && isFirstPost && document.getElementById('content').value !== '') {
    isFirstPost = false;
    document.getElementById('homete').click();
  }
};
const isPressedSubmitKey = (keyEvent) => {
  return keyEvent.key === 'Enter' && (keyEvent.ctrlKey || keyEvent.metaKey);
};

const showNotice = function(notice){
    let targets = document.getElementsByClassName("rt-notice");
    if (targets.length == 1){
        let target = targets[0];
        target.style.display = "block";
        target.innerHTML = notice;
        noticeCount++;
        window.setTimeout(function(){
            let targets = document.getElementsByClassName("rt-notice");
            noticeCount--;
            if (targets.length == 1 && noticeCount == 0){
                let target = targets[0];
                target.style.display = "none";
            }            
        }, 2500);
    }
}

window.followUser = function(screen_name){
    let target = "/follow/" + screen_name;
    let request = new XMLHttpRequest();
    request.open('GET', target, true);
    request.onload = function() {
        if (this.status >= 200 && this.status < 400) {
            let response = JSON.parse(this.response);
            if(response.success){
                document.getElementById('unfollow').style.display = "inline-block";
                document.getElementById('follow').style.display = "none";
                if(!response.refollow) {
                    let follower_count = document.getElementById('follower_count').innerHTML;
                    follower_count++;
                    document.getElementById('follower_count').innerHTML = follower_count;
                }
                showNotice("フォローしました。");
            } else {
                showNotice(response.message);
            }
        } else {
            showNotice("原因不明のエラーです。");
        }
    };
    
    request.onerror = function() {
        showNotice("原因不明のエラーです。");
    };
    
    request.send();
}

window.unfollowUser = function(screen_name){
    let target = "/unfollow/" + screen_name;
    let request = new XMLHttpRequest();
    request.open('GET', target, true);
    request.onload = function() {
        if (this.status >= 200 && this.status < 400) {
            let response = JSON.parse(this.response);
            if(response.success){
                document.getElementById('follow').style.display = "inline-block";
                document.getElementById('unfollow').style.display = "none";
                showNotice("フォロー解除しました。");
            } else {
                showNotice(response.message);
            }
        } else {
            showNotice("原因不明のエラーです。");
        }
    };
    
    request.onerror = function() {
        showNotice("原因不明のエラーです。");
    };
    
    request.send();
}

window.muteUser = function(screen_name){
    let target = "/mute/enable/" + screen_name;
    let request = new XMLHttpRequest();
    request.open('GET', target, true);
    request.onload = function() {
        if (this.status >= 200 && this.status < 400) {
            let response = JSON.parse(this.response);
            if(response.success){
                document.getElementById('unmute').style.display = "inline-block";
                document.getElementById('mute').style.display = "none";
                showNotice("ミュートしました。");
            } else {
                showNotice(response.message);
            }
        } else {
            showNotice("原因不明のエラーです。");
        }
    };
    
    request.onerror = function() {
        showNotice("原因不明のエラーです。");
    };
    
    request.send();
}

window.unmuteUser = function(screen_name){
    let target = "/mute/disable/" + screen_name;
    let request = new XMLHttpRequest();
    request.open('GET', target, true);
    request.onload = function() {
        if (this.status >= 200 && this.status < 400) {
            let response = JSON.parse(this.response);
            if(response.success){
                document.getElementById('mute').style.display = "inline-block";
                document.getElementById('unmute').style.display = "none";
                showNotice("ミュート解除しました。");
            } else {
                showNotice(response.message);
            }
        } else {
            showNotice("原因不明のエラーです。");
        }
    };
    
    request.onerror = function() {
        showNotice("原因不明のエラーです。");
    };
    
    request.send();
}


window.homeru = function(target_id, type){
    let target = "/homeru/create/" + target_id + "/" + type;
    let request = new XMLHttpRequest();
    request.open('GET', target, true);
    request.onload = function() {
        if (this.status >= 200 && this.status < 400) {
            let response = JSON.parse(this.response);
            if(!response.success){
                //alert(response.message);
                showNotice("すでにほめています！");
            } else {
                let val = document.getElementById("homeru_" + target_id + "_" + type);
                let count = val.innerHTML;
                count++;
                val.innerHTML = count;
                val.style.textDecoration = "underline";

                val = document.getElementById("homeru_" + target_id + "_all");
                count = val.innerHTML;
                count++;
                val.innerHTML = count;

                val = document.getElementById("homete_" + target_id);
                val.style.background = "#FEF9F2";

                const types = ['えらい','かわいそう','かわいい','かっこいい'];
                showNotice("「" + types[type-1] + "」をおくりました！");
            }
        } else {
            showNotice("原因不明のエラーです。");
        }
    };
    
    request.onerror = function() {
        showNotice("原因不明のエラーです。");
    };
    
    request.send();

}

window.destroy = function(target_id){
    if(!window.confirm('本当に削除しますか？')){
        return;
    }

    let target = "/homete/destroy_ajax/" + target_id;
    let request = new XMLHttpRequest();
    request.open('GET', target, true);
    request.onload = function() {
        if (this.status >= 200 && this.status < 400) {
            let response = JSON.parse(this.response);
            if(!response.success){
                //alert(response.message);
                showNotice("削除に失敗しました。");
            } else {
                let homete = document.getElementById("homete_" + target_id);
                homete.style.display = "none";
                showNotice("ほめてを削除しました。");
            }
        } else {
            showNotice("原因不明のエラーです。");
        }
    };
    
    request.onerror = function() {
        showNotice("原因不明のエラーです。");
    };
    
    request.send();
}

window.showPostBox = function() {
    document.getElementById('show_post_box').style.display = "none";
    document.getElementById('hide_post_box').style.display = "inline-block";
    document.getElementById('post_box').style.display = "block";
}

window.hidePostBox = function() {
    document.getElementById('show_post_box').style.display = "inline-block";
    document.getElementById('hide_post_box').style.display = "none";
    document.getElementById('post_box').style.display = "none";
}

window.hamburger = function() {
    document.getElementById('navigator').classList.toggle('in');
}

window.open_help = function(n){
    document.getElementById('help_homeru_' + n).style.visibility = "visible";
}

window.close_help = function(n){
    document.getElementById('help_homeru_' + n).style.visibility = "hidden";
}

document.addEventListener('click', (e) => {
    if(!e.target.closest('.open-help-homeru')) {
        let buttons = document.getElementsByClassName('help-homeru');
        let i;
        for (i = 0; i < buttons.length; i++){
            buttons[i].style.visibility = "hidden";
        }
    } 
})

Rails.start()
Turbolinks.start()
//ActiveStorage.start()