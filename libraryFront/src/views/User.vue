<template>
  <div class="home" style ="padding: 10px">
<!-- 按钮-->
<!-- 搜索-->
    <div style="margin: 10px 0;">
      <el-form inline="true" size="small">
        <el-form-item label="UID" >
      <el-input v-model="search1" placeholder="Please enter UID"  clearable>
        <template #prefix><el-icon class="el-input__icon"><search/></el-icon></template>
      </el-input>
          </el-form-item >
        <el-form-item label="Name" >
          <el-input v-model="search2" placeholder="Please enter name"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search /></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item label="Phone Number" >
          <el-input v-model="search3" placeholder="Please enter phone number"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search /></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item label="Address" >
          <el-input v-model="search4" placeholder="Please enter address"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search /></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item>
      <el-button type="primary" style="margin-left: 1%" @click="load" size="mini">Search</el-button>
        </el-form-item>
        <el-form-item>
          <el-button size="mini"  type="danger" @click="clear">Reset</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 按钮-->
    <div style="margin: 10px 0;" >
      <el-popconfirm title="Please confirm to delete" @confirm="deleteBatch" v-if="user.role == 1">
        <template #reference>
          <el-button type="danger" size="mini" >Batch Delete</el-button>
        </template>
      </el-popconfirm>
    </div>
<!-- 数据字段-->
    <el-table :data="tableData" stripe border="true"  @selection-change="handleSelectionChange" >
      <el-table-column v-if="user.role ==1 "
                       type="selection"
                       width="55">
      </el-table-column>
      <el-table-column prop="id" label="UID" sortable />
      <el-table-column prop="username" label="Username" />
      <el-table-column prop="nickName" label="Name" />
      <el-table-column prop="phone" label="Phone Number" />
      <el-table-column prop="sex" label="Gender" />
      <el-table-column prop="address" label="Address" />
      <el-table-column fixed="right" label="Options" >
        <template v-slot="scope">
          <el-button  size="mini" @click ="handleEdit(scope.row)">Edit</el-button>
          <el-popconfirm title="Please confirm to delete" @confirm="handleDelete(scope.row.id)">
            <template #reference>
              <el-button type="danger" size="mini" >Delete</el-button>
            </template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
<!--    分页-->
    <div style="margin: 10px 0">
      <el-pagination
          v-model:currentPage="currentPage"
          :page-sizes="[5, 10, 20]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
      >
      </el-pagination>

      <el-dialog v-model="dialogVisible" title="Edit Patron Information" width="30%">
        <el-form :model="form" label-width="120px">
          <el-form-item label="Username">
            <el-input style="width: 80%" v-model="form.username"></el-input>
          </el-form-item>
          <el-form-item label="Name">
            <el-input style="width: 80%" v-model="form.nickName"></el-input>
          </el-form-item>
          <el-form-item label="Phone Number">
            <el-input style="width: 80%" v-model="form.phone"></el-input>
          </el-form-item>
          <el-form-item label="Gender">
            <div>
              <el-radio v-model="form.sex" label="Male">Male</el-radio>
              <el-radio v-model="form.sex" label="Female">Female</el-radio>
            </div>
          </el-form-item>
          <el-form-item label="Address">
            <el-input type="textarea" style="width: 80%" v-model="form.address"></el-input>
          </el-form-item>
        </el-form>
        <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="save">Save</el-button>
      </span>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import request from "../utils/request";
import {ElMessage} from "element-plus";

export default {
  created(){
    this.load()
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
  },
  name: 'LUser',
  methods: {
    handleSelectionChange(val){
      this.ids = val.map(v => v.id)
    },
    deleteBatch(){
      if (!this.ids.length) {
        ElMessage.warning("Please choose one at least!")
        return
      }
      //  一个小优化，直接发送这个数组，而不是一个一个的提交删除
      request.post("http://localhost:8181/user/deleteBatch",this.ids).then(res =>{
        if(res.code === '0'){
          ElMessage.success("Successfully batch delete!")
          this.load()
        }
        else {
          ElMessage.error(res.msg)
        }
      })
    },
    load(){
      request.get("http://localhost:8181/user/usersearch",{
        params:{
          pageNum: this.currentPage,
          pageSize: this.pageSize,
          search1: this.search1,
          search2: this.search2,
          search3: this.search3,
          search4: this.search4,
        }
      }).then(res =>{
        console.log(res)
        this.tableData = res.data.records
        this.total = res.data.total
      })
    },
    clear(){
      this.search1 = ""
      this.search2 = ""
      this.search3 = ""
      this.load()
    },

    handleDelete(id){
      request.delete("http://localhost:8181/user/" + id ).then(res =>{
        console.log(res)
        if(res.code == 0 ){
          ElMessage.success("Successfully delete!")
        }
        else
          ElMessage.error(res.msg)
        this.load()
      })
    },


    add(){
      this.dialogVisible= true
      this.form ={}
    },
    save(){
      if(this.form.id){
        request.put("http://localhost:8181/user",this.form).then(res =>{
          console.log(res)
          if(res.code == 0){
            ElMessage({
              message: 'Successfully Update!',
              type: 'success',
            })
          }
          else {
            ElMessage.error(res.msg)
          }

          this.load() //不知道为啥，更新必须要放在这里面
          this.dialogVisible = false
        })
      }
      else {
        request.post("http://localhost:8181/user",this.form).then(res =>{
          console.log(res)
          if(res.code == 0){
            ElMessage.success('Successfully Save!')
          }
          else {
            ElMessage.error(res.msg)
          }
          this.load()
          this.dialogVisible = false
        })
      }

    },


    handleEdit(row){
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogVisible = true
    },
    handleSizeChange(pageSize){
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum){
      this.pageNum = pageNum
      this.load()
    },
  },
  data() {
    return {
      form: {},
      dialogVisible : false,
      search1:'',
      search2:'',
      search3:'',
      search4:'',
      total:10,
      currentPage:1,
      pageSize: 10,
      tableData: [

      ],
      user:{},
      ids:[],
    }
  },
}
</script>
