<template>
  <div>
    <el-card style="width: 40%; margin-left: 120px; margin-top: 40px" >
      <el-form
          ref="form"
          :model="form"
          status-icon
          :rules="rules"
          label-width="100px"
          class="demo-ruleForm"
      >
        <el-form-item label="Original Password" prop="password2">
          <el-input
              v-model="form.password2"
              type="password"
              autocomplete="off"
          ></el-input>
        </el-form-item>
        <el-form-item label="New Password" prop="password">
          <el-input
              v-model="form2.password"
              type="password"
              autocomplete="off"
          ></el-input>
        </el-form-item>
        <el-form-item label="Enter again" prop="checkpassword">
          <el-input
              v-model="form.checkpassword"
              type="password"
              autocomplete="off"
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm" style="text-align: center">Submit</el-button>
          <el-button @click="resetForm('form')" style="text-align: center">Reset</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import request from "../utils/request";
import {ElMessage} from "element-plus";

export default {
  name: "LPassword",
  data() {
    const validatePass2 = (rule, value, callback) => {
      if (value == '') {
        callback(new Error('Please enter original password'))
      } else {
        if (this.form.password2 !== this.form.truepassword) {
          callback(new Error('Wrong Original Password'))
        }
        callback()
      }
    }
    const validatePass = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please enter new password'))
      } else {
        // if (this.form2.password !== '') {
        //   this.$refs.form.validateField('newPass')
        // }
        callback()
      }
    }
    const validatePass3 = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please enter agian'))
      } else if (value !== this.form2.password) {
        callback(new Error("The passwords entered twice are inconsistent"))
      } else {
        callback()
      }
    }
    return {
      form: {
        password2: '',
        checkpassword: '',
        truepassword:'',
      },
      form2:{
        password:'',
        id:0
      },
      rules: {
        password: [{ validator: validatePass, trigger: 'blur' ,required: true}],
        checkpassword: [{ validator: validatePass3, trigger: 'blur',required: true,}],
        password2: [{ validator: validatePass2, trigger: 'blur',required: true,}],
      },
    }
  },
  created() {
    let user = JSON.parse(sessionStorage.getItem("user"))
    this.form.truepassword = user.password
    this.form2.id = user.id

  },
  methods: {
    submitForm() {
      this.$refs['form'].validate((valid) => {
        if (valid) {

          request.put("http://localhost:8181/user", this.form2).then(res => {
            if (res.code == 0) {
              ElMessage.success("Password modified successfully.Please login again.")
              sessionStorage.removeItem("user")//清空缓存的用户信息
              this.$router.push("/login")//跳转登录界面
            } else {
              ElMessage.error(res.msg)
            }
          })
        }
      })
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
  },
}
</script>

<style scoped>

</style>
