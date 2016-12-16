
require('./bootstrap');

Vue.component('Countdown', require('./components/CountDown.vue'));


var app = new Vue({
    el: '#app'
});
