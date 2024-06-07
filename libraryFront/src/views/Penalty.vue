<template>
  <div class="container">
    <h1 class="title">Pay for Penalty</h1>
    <div class="image-container">
      <img src="@/img/pay.jpg" alt="pay" class="pay-image" />
      <p class="image-text">You need to pay $ {{this.penalty}} !</p>
    </div>
    <button class="return-button" @click="goBack">Return</button>
    <button class="pay-button" @click="pay">Yes</button>
  </div>
</template>

<script>
import request from "@/utils/request";
import {ElMessage} from "element-plus";

export default {
  created() {
    this.penalty=this.$route.params.money
  },
  name: 'PaymentReminder',
  data(){
    return{
      penalty:0
    }
  },
  methods: {
    goBack() {
      window.history.back();
    },
    pay(){
      console.log(this.$route.params.id)
      request.get('http://localhost:8181/bookwithuser/updateDeadtime/'+this.$route.params.id).then(res => {
        console.log(res);
        if (res.code==0) {
          ElMessage({
            message: 'Successfully pay!',
            type: 'success',
          })
          window.history.back()
        } else {
          ElMessage.error(res.msg)
        }
      }).catch(error => {
        console.error(error); // 打印任何请求错误
      })
    }
  }
};
</script>

<style>
.container {
  text-align: center;
}

.title {
  font-size: 40px;
  margin-top: 20px;
}

.image-container {
  margin-top: 20px;
}

.pay-image {
  width: 200px;
  height: 200px;
}

.image-text {
  margin-top: 10px;
}

body {
  margin: 0;
  padding: 0;
  background-color: white;
  color: black;
}

.return-button {
  position: fixed;
  bottom: 20px;
  right: 20px;
  padding: 10px 20px;
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.return-button:hover {
  background-color: rgba(0, 0, 0, 0.29);
}

.pay-button {
  position: fixed;
  bottom: 20px;
  right: 130px;
  padding: 10px 20px;
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.pay-button:hover {
  background-color: rgba(0, 0, 0, 0.29);
}

.container {
  text-align: center;
  background-image: url('@/img/background.jpg');
  background-size: cover;

  background-position: center;
  height: 100vh; /* 设置容器高度为视窗高度，以填满整个屏幕 */
  padding-bottom: 56.25%; /* 根据您的图片宽高比进行调整 */

  /* 设置容器的宽度为 100%，这样它就能与视口宽度相同（减去任何边距或边框）*/
  width: 100%;

  /* 使用 position: relative 和伪元素（如果需要）来在背景图片上放置其他内容 */
  position: relative;

  /* 其他样式... */
  box-sizing: border-box; /* 确保 padding 不会增加容器的实际宽度 */
  margin: 0; /* 移除任何外边距 */
  overflow: hidden;
}

.element {
  padding: 0;
}

#app {
  padding: 0px;
}


* {
  margin: 0;

  padding: 0;
  box-sizing: border-box;
}

</style>
