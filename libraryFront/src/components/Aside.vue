<template>
<div>


  <el-menu
      style="width: 200px; min-height: calc(100vh - 50px);"
      :default-active="path"
      class="el-menu-vertical-demo"
      @open="handleOpen"
      @close="handleClose"
      router
      background-color="#30333c" text-color="#fff"
  >
    <el-menu-item index="/Welcome" >
      <svg class="icon" aria-hidden="true">
        <use xlink:href="#el-icon-house "></use>
      </svg>
      <span>Welcome</span>
    </el-menu-item>
    <el-menu-item index="/dashboard" >
      <svg class="icon" aria-hidden="true">
        <use xlink:href="#icondashboard "></use>
      </svg>
      <span>Dashboard</span>
    </el-menu-item>
    <el-sub-menu index="2" text-color="#fff">
      <template #title>
        <svg class="icon" aria-hidden="true">
          <use xlink:href="#icon-mingpian "></use>
        </svg>
        <span>Personal Information</span>
      </template>
      <el-menu-item index="/person" style="font-color: white">
        <svg class="icon" aria-hidden="true">
          <use xlink:href="#icon-a-bianji1 "></use>
        </svg>
        <span>Modify Information</span>
      </el-menu-item>
      <el-menu-item index="/password">
        <svg class="icon" aria-hidden="true">
          <use xlink:href="#icon-mima "></use>
        </svg>
        <span>Modify Password</span>
      </el-menu-item>
    </el-sub-menu>
    <el-menu-item index="/user" v-if="user.role == 1">
      <svg class="icon" aria-hidden="true">
        <use xlink:href="#iconreader "></use>
      </svg>
      <span>Patron Management</span>
    </el-menu-item>
    <el-menu-item index="/book" v-if="user.role == 1" >
      <svg class="icon" aria-hidden="true">
        <use xlink:href="#iconbook "></use>
      </svg>
      <span>Book Management</span>
    </el-menu-item>
    <el-menu-item index="/book" v-if="user.role == 2">
      <svg class="icon" aria-hidden="true">
        <use xlink:href="#iconbook "></use>
      </svg>
      <span>Book Search</span>
    </el-menu-item>
    <el-menu-item index="/lendrecord" v-if="user.role == 1">
      <svg class="icon" aria-hidden="true">
        <use xlink:href="#iconlend-record "></use>
      </svg>
      <span>Borrow History</span>
    </el-menu-item>
    <el-menu-item index="/lendrecord" v-if="user.role == 2">
      <svg class="icon" aria-hidden="true">
        <use xlink:href="#iconlend-record"></use>
      </svg>
      <span>Borrow History</span>
    </el-menu-item>
    <el-menu-item index="/bookwithuser" >
      <el-icon><grid /></el-icon>
      <span>Borrow Status</span>
    </el-menu-item>
    <el-menu-item index="/like" v-if="user.role !== 1">
      <StarFilled class="icon"></StarFilled>
      <span>Your Like</span>
    </el-menu-item>
    <div class="bottom-button">
      <el-button type="text" class="button" @click="$router.push('/feedback')" >Feedback</el-button>
    </div>
  </el-menu>

</div>
</template>

<script>



import {StarFilled} from "@element-plus/icons-vue";

export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "Aside",
  components:{StarFilled},
  created(){
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
  },
  data(){
    return {
      user:{},
      path: this.$route.path
    }
  }
}
</script>

<style scoped>
.icon {
  width: 30px;
  height: 30px;
  padding-top: 5px;
  padding-right: 10px;
}
.bottom-button{
  position: fixed; /* 或者使用 absolute/relative，根据你的布局需求 */
  bottom: 20px; /* 距离页面底部的距离 */
  left: 55px; /* 距离页面左侧的距离 */
  display: flex; /* 使用 flexbox 来定位按钮（虽然在这个场景下可能不是必需的）*/
  align-items: center; /* 垂直居中（如果按钮需要额外的内部元素）*/
  z-index: 999;
}
.button{
  font-size:15px;
  text-decoration: underline;
}
</style>
