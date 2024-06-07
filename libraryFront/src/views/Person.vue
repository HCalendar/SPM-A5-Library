<template>
  <div>
    <el-card style="width: 40%; margin-left: 120px; margin-top: 40px" >
        <h2 style="padding: 30px">Personal Information</h2>
      <el-form :model="form" ref="form" label-width="80px">
        <el-form-item label="User">
          <el-input a v-model="form.username" disabled></el-input>
        </el-form-item>
        <el-form-item label="Name">
          <el-input style="width: 80%" v-model="form.nickName"></el-input>
        </el-form-item>
        <el-form-item label="Role">
            <span v-if="form.role==1" style="margin:5px">Librarian</span>
            <span v-if="form.role==2" style="margin:5px">Patron</span>
        </el-form-item>
        <el-form-item label="Phone Number">
          <el-input style="width: 80%" v-model="form.phone"></el-input>
        </el-form-item>
        <el-form-item label="Gender">
          <div>
            <el-radio v-model="form.sex" label="男">Male</el-radio>
            <el-radio v-model="form.sex" label="女">Female</el-radio>
          </div>
        </el-form-item>
        <el-form-item label="Address">
          <el-input type="textarea" style="width: 80%" v-model="form.address"></el-input>
        </el-form-item>
      </el-form>
      <div style="text-align: center">
        <el-button type="primary" @click="update">Save</el-button>
      </div>
    </el-card>
  </div>
</template>

<script>
import request from "@/utils/request";
import {ElMessage} from "element-plus";

export default {
  name: "LPerson",
  data() {
    return {
      form: {}
    }
  },
  created() {
    let str = sessionStorage.getItem("user") || "{}"
    this.form = JSON.parse(str)
  },
  methods: {
    update() {
      request.put("http://localhost:8181/user", this.form).then(res => {
        console.log(res)
        if (res.code === '0') {
          ElMessage.success("Successfully Update!")
          sessionStorage.setItem("user", JSON.stringify(this.form))
          // 触发Layout更新用户信息
          this.$emit("userInfo")
        } else {
          ElMessage.error(res.msg)
        }
      })

    }
  }
}
</script>

<style>
.avatar-uploader  {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader:hover {
  border-color: #409EFF;
}

.avatar {
  width: 178px;
  height: 178px;
  display: block;
}
.box-card {
  width: 60%;
  margin: auto;
  padding: 20px;
}
</style>
