<template>
 <div style="height: 50px; line-height:50px; border-bottom: 1px solid #ccc; display: flex">
   <div style="width: 200px; padding-left:30px; font-weight: bold; color:dodgerblue">
     <img :src="imgUrl" class="icon" >
     LMS-A5</div>
   <div style="flex: 1"></div>
   <div style="width: 100px">
     <el-dropdown>
      <span class="el-dropdown-link">
        {{user.username}} <el-icon class="el-icon--right">
          <arrow-down />
          </el-icon>
      </span>
       <template #dropdown>
         <el-dropdown-menu>
           <el-dropdown-item @click="exit">Exit</el-dropdown-item>
         </el-dropdown-menu>
       </template>
     </el-dropdown>
   </div>
 </div>
</template>

<script>
import {ElMessage} from "element-plus";

export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "Header",
  props: ['user'],
  data(){
    return{
      // eslint-disable-next-line vue/no-dupe-keys
      user:[],
      imgUrl:require("../assets/icon/login.png")
    }
  },
  created(){
    let userStr = sessionStorage.getItem("user")||"{}"
    // eslint-disable-next-line vue/no-mutating-props
    this.user = JSON.parse(userStr)
  },
  methods:{
    exit(){
      sessionStorage.removeItem("user")
      this.$router.push("/login")
      ElMessage.success("Exit Success!")
    }
  }

}
</script>

<style scoped>
.icon {
  width: 40px;
  height: 40px;
  padding-top: 5px;
  padding-right: 10px;
}
</style>
