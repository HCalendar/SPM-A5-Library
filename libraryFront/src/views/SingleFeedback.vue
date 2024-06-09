<template>
  <div class="info-container">
    <el-card class="card-with-button" style="width: 80%;margin-left: 120px; margin-top: 10px;background: beige" >
      <div class="card-content">
        <p v-if="this.role !== 1">Your advice: {{ info.content }}</p>
        <p v-if="this.role === 1">Patron advice: {{ info.content }}</p>
        <p v-if="info.backcontent !== ''">By {{info.adminname}} Reply: {{ info.backcontent }}</p>
        <p v-if="info.backcontent === ''">No Reply Yet</p>
      </div>
      <div class="card-actions" v-if="this.role === 1">
        <el-button type="mini" size="mini" @click="open()">Reply</el-button>
      </div>
    <el-dialog v-model="dialogVisible" title="Reply" width="30%">
      <el-form :model="form" label-width="120px">
          <el-input style="width: 100%" v-model="back"></el-input>
      </el-form>
      <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="submit(info)">Submit</el-button>
      </span>
      </template>
    </el-dialog>
    </el-card>
  </div>
</template>

<script>
import request from "@/utils/request";
import {ElMessage} from "element-plus";

export default {
  props: ['info'],
  created(){
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
    this.userid=this.user.id
    this.username=this.user.username
    this.role=this.user.role
    console.log(this.role)
  },
  methods:{
    open(){
      this.dialogVisible=true
    },
    submit(info){
      info.backcontent=this.back;
      info.adminname=this.username;
      request.post('http://localhost:8181/feedback/updateCom',info).then(res=>{
        console.log(res)
        if(res.code == 0 ){
          ElMessage.success("Successfully reply!")
        }
        else
          ElMessage.error(res.msg)
        this.dialogVisible=false
        window.location.reload()
      })
    }
  },
  data(){
    return{
      userid:"",
      username:"",
      role:0,
      dialogVisible: false,
      back:""
    }
  },
}
</script>

<style scoped>
.card-with-button {
  display: flex;
  flex-direction: column; /* 默认是column，但这里明确一下 */
}

.card-content {
  /* 这里可以根据需要设置内容的样式 */
  flex: 1; /* 让内容占据剩余空间 */
}

.card-actions {
  display: flex;
  justify-content: flex-end; /* 将子元素（按钮）对齐到右边 */
  margin-top: auto; /* 将动作栏推到card的底部（如果有垂直空间的话） */
}
</style>
