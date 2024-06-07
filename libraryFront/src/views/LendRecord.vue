<template>
  <div class="home" style ="padding: 10px">

    <!-- 搜索-->
    <div style="margin: 10px 0;">
      <el-form inline="true" size="small">
        <el-form-item label="ISBN" >
          <el-input v-model="search1" placeholder="Please enter ISBN"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search/></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item label="Title" >
          <el-input v-model="search2" placeholder="Please enter title"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search /></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item v-if="user.role === 1" label="Patron ID" >
          <el-input v-model="search3" placeholder="Please enter patron ID"  clearable>
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

<!--按钮-->
    <div style="margin: 10px 0;" v-if="user.role == 1">
      <el-popconfirm title="Please confirm to delete" @confirm="deleteBatch" >
        <template #reference>
          <el-button type="danger" size="mini" >Batch Delete</el-button>
        </template>
      </el-popconfirm>
    </div>
    <!-- 数据字段-->

    <el-table :data="tableData" stripe border="true" @selection-change="handleSelectionChange">
      <el-table-column v-if="user.role ==1"
                       type="selection"
                       width="55">
      </el-table-column>
      <el-table-column prop="isbn" label="ISBN" sortable />
      <el-table-column prop="bookname" label="Title" />
      <el-table-column v-if="user.role === 1" prop="readerId" label="Patron ID" sortable/>
      <el-table-column prop="lendTime" label="Borrow Time" sortable/>
      <el-table-column prop="returnTime" label="Return Time" sortable/>
      <el-table-column prop="status" label="Status" >
        <template v-slot="scope">
          <el-tag v-if="scope.row.status == 0" type="warning">Not Returned</el-tag>
          <el-tag v-else type="success">Returned</el-tag>
        </template>
      </el-table-column>
      <el-table-column v-if="user.role === 1" label="Options" width="230px">
        <template v-slot="scope">
          <el-button  size="mini" @click ="handleEdit(scope.row)">Edit</el-button>
          <el-popconfirm title="Please confirm to delete" @confirm="handleDelete(scope.row)">
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


      <el-dialog v-model="dialogVisible" title="Modify Borrow History" width="30%">
        <el-form :model="form" label-width="120px">
          <el-form-item label="Borrow Time" >
            <el-date-picker
                v-model="form.lendTime"
                type="datetime"
                value-format="YYYY-MM-DD HH:mm:ss"
            >
            </el-date-picker>
          </el-form-item>
          <el-form-item label="Return Time" >

            <el-date-picker
                v-model="form.returnTime"
                type="datetime"
                value-format="YYYY-MM-DD HH:mm:ss"
            >
            </el-date-picker>

          </el-form-item>
          <el-form-item label="Is Return" prop="status">
            <el-radio v-model="form.status" label="0">Not Returned</el-radio>
            <el-radio v-model="form.status" label="1">Returned</el-radio>
          </el-form-item>
        </el-form>
        <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="save(form.isbn)">Save</el-button>
      </span>
        </template>
      </el-dialog>
    </div>
  </div>

</template>

<script >

import request from "../utils/request";
import {ElMessage} from "element-plus";
import { defineComponent, reactive, toRefs } from 'vue'

export default defineComponent({

  created(){
    this.load()
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
  },
  name: 'LLendRecord',
  methods: {
    handleSelectionChange(val){
      this.forms = val
    },
    deleteBatch(){
      if(!this.forms.length){
        ElMessage.warning("Please choose one at least")
        return
      }
      request.post("http://localhost:8181/LendRecord/deleteRecords",this.forms).then(res =>{
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
      request.get("http://localhost:8181/LendRecord",{
        params:{
          pageNum: this.currentPage,
          pageSize: this.pageSize,
          search1: this.search1,
          search2: this.search2,
          search3: this.search3
        }
      }).then(res =>{
        console.log(res)
        if (this.user.role === 2){
          this.tableData = res.data.records.filter(book => book.readerId === this.user.id)
          this.total = this.tableData.length
        }
        if(this.user.role === 1){
          this.tableData = res.data.records
          this.total = res.data.total
        }
      })
    },
    save(isbn){
      //ES6语法
      //地址,但是？IP与端口？+请求参数
      // this.form?这是自动保存在form中的，虽然显示时没有使用，但是这个对象中是有它的
      if(this.form.isbn){
        request.post("http://localhost:8181/LendRecord" + isbn, this.form).then(res => {
          console.log(res)
          if (res.code == 0) {
            ElMessage({
              message: 'Successfully Add!',
              type: 'success',
            })
          } else {
            ElMessage.error(res.msg)
          }

          this.load() //不知道为啥，更新必须要放在这里面
          this.dialogVisible = false
        })
      }
      else {
        request.put("http://localhost:8181/LendRecord/" + isbn, this.form).then(res => {
          console.log(res)
          if (res.code == 0) {
            ElMessage({
              message: 'Successfully Update!',
              type: 'success',
            })
          } else {
            ElMessage.error(res.msg)
          }

          this.load() //不知道为啥，更新必须要放在这里面
          this.dialogVisible2 = false
        })
      }

    },
    clear(){
      this.search1 = ""
      this.search2 = ""
      this.search3 = ""
      this.load()
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
    handleDelete(row){
      const form3 = JSON.parse(JSON.stringify(row))
      request.post("http://localhost:8181/LendRecord/deleteRecord",form3).then(res =>{
        console.log(res)
        if(res.code == 0 ){
          ElMessage.success("Successfully Delete!")
        }
        else
          ElMessage.error(res.msg)
        this.load()
      })
    },
    add(){
      this.dialogVisible2 = true
      this.form ={}
    }
  },

  setup() {
    const state = reactive({
      shortcuts: [
        {
          text: 'Today',
          value: new Date(),
        },
        {
          text: 'Yesterday',
          value: () => {
            const date = new Date()
            date.setTime(date.getTime() - 3600 * 1000 * 24)
            return date
          },
        },
        {
          text: 'A week ago',
          value: () => {
            const date = new Date()
            date.setTime(date.getTime() - 3600 * 1000 * 24 * 7)
            return date
          },
        },
      ],
      value1: '',
      value2: '',
      value3: '',
      defaultTime: new Date(2000, 1, 1, 12, 0, 0), // '12:00:00'
    })

    return toRefs(state)
  },
  data() {
    return {
      form: {},
      search1:'',
      search2:'',
      search3:'',
      total:10,
      currentPage:1,
      pageSize: 10,
      tableData: [],
      user:{},
      dialogVisible : false,
      dialogVisible2: false,
      targetReaderId: 0,
    }
  }
})
</script>
