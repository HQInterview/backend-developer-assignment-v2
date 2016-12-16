<template>
    <div class="row">
        <div class=" col-sm-4 ">
            <!-- countdown -->
            <ul id="countdown"> 
              <li class="time-wrap col-xs-6 col-sm-3">
                  <span class="time">{{ minutes | two_digits }}</span>
                  <p class="unit">minutes</p>
              </li>
              <li class="time-wrap col-xs-6 col-sm-3">
                  <span class="time">{{ seconds | two_digits }}</span>
                  <p class="unit">seconds</p>
              </li>
          </ul>
      </div>
  </div>

</template>


<script>

   export default {
    props: {
        date: {
            type: String,
            coerce: str => Math.trunc(Date.parse(str) / 1000)
        },
        now:{
            type: String,
            default: Math.trunc((new Date()).getTime() / 1000)
        }
    },
    computed: {

        seconds() { 
            var seconds = (this.remainDateValue - this.now) % 60;
            if ( seconds >= 0  )
                return (this.remainDateValue - this.now) % 60;
            else
                return 0;
        },

        minutes() {
         var minutes = Math.trunc((this.remainDateValue - this.now) / 60) % 60;
         if ( minutes >= 0  )
            return Math.trunc((this.remainDateValue - this.now) / 60) % 60;
        else
            return 0;
    },
    // change date to numbers
    remainDateValue() {
        return Math.trunc(Date.parse(this.date) / 1000);
    },

},
created () {
    // change now time every one second
    window.setInterval(() => {
        this.now = Math.trunc((new Date()).getTime() / 1000);
    },1000);
},
filters:{
    two_digits: function(value){
        if(value.toString().length <= 1)
        {
            return "0"+value.toString();
        }
        return value.toString();
    }
}
};
</script>

<style scoped>
    #countdown {
        list-style: none;
        padding-left: 0;
        margin: 0;
        display: inline-block;
        width: 100%;
        max-width: 600px;
    }
    .unit {
        text-transform: uppercase;
        letter-spacing: 0.1em;
        margin-top: 5px;
        font-size: 8px;
    }
    .time-wrap {
        padding: 0;
    }
    .time {
        letter-spacing: 0.05em;
        display: inline-block;
    }
</style>


