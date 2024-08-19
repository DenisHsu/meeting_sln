<template>
    <div>
        <h1>公司數據管理</h1>

        <section>
            <h2>查詢公司數據</h2>
            <form @submit.prevent="getCompanyData">
                <label for="queryCompanyCode">公司代號:</label>
                <input type="text" id="queryCompanyCode" v-model="queryCompanyCode" required />

                <label for="queryDataMonth">資料月份:</label>
                <input type="text" id="queryDataMonth" v-model="queryDataMonth" required />

                <button type="submit">查詢</button>
            </form>

            <div v-if="companyData">
                <h3>查詢結果:</h3>
                <pre>{{ companyData }}</pre>
            </div>

            <div v-if="queryErrorMessage">{{ queryErrorMessage }}</div>
        </section>

        <hr />

        <section>
            <h2>新增公司數據</h2>
            <form @submit.prevent="addCompanyData">
                <label for="addCompanyCode">公司代號:</label>
                <input type="text" id="addCompanyCode" v-model="newCompany.CompanyCode" required />

                <label for="addCompanyName">公司名稱:</label>
                <input type="text" id="addCompanyName" v-model="newCompany.CompanyName" required />

                <label for="addIndustry">產業別:</label>
                <input type="text" id="addIndustry" v-model="newCompany.Industry" required />

                <label for="addDataMonth">資料月份:</label>
                <input type="text" id="addDataMonth" v-model="newCompany.DataMonth" required />

                <label for="addRevenueCurrentMonth">當月營收:</label>
                <input type="number" id="addRevenueCurrentMonth" v-model="newCompany.RevenueCurrentMonth" required />

                <label for="addRevenueLastMonth">上月營收:</label>
                <input type="number" id="addRevenueLastMonth" v-model="newCompany.RevenueLastMonth" required />

                <label for="addRevenueSameMonthLastYear">去年同月營收:</label>
                <input type="number" id="addRevenueSameMonthLastYear" v-model="newCompany.RevenueSameMonthLastYear" required />

                <label for="addRevenueChangeLastMonth">上月比較增減(%):</label>
                <input type="number" step="0.01" id="addRevenueChangeLastMonth" v-model="newCompany.RevenueChangeLastMonth" required />

                <label for="addRevenueChangeLastYear">去年同月增減(%):</label>
                <input type="number" step="0.01" id="addRevenueChangeLastYear" v-model="newCompany.RevenueChangeLastYear" required />

                <label for="addCumulativeRevenueCurrentYear">當月累計營收:</label>
                <input type="number" id="addCumulativeRevenueCurrentYear" v-model="newCompany.CumulativeRevenueCurrentYear" required />

                <label for="addCumulativeRevenueLastYear">去年累計營收:</label>
                <input type="number" id="addCumulativeRevenueLastYear" v-model="newCompany.CumulativeRevenueLastYear" required />

                <label for="addCumulativeRevenueChange">前期比較增減(%):</label>
                <input type="number" step="0.01" id="addCumulativeRevenueChange" v-model="newCompany.CumulativeRevenueChange" required />

                <label for="addRemarks">備註:</label>
                <textarea id="addRemarks" v-model="newCompany.Remarks"></textarea>

                <label for="addReportDate">報告日期:</label>
                <input type="text" id="addReportDate" v-model="newCompany.ReportDate" required />

                <button type="submit">新增公司數據</button>
            </form>

            <div v-if="addErrorMessage">{{ addErrorMessage }}</div>
            <div v-if="addSuccessMessage">{{ addSuccessMessage }}</div>
        </section>
    </div>
</template>

<script>
export default {
  data() {
    return {
      
      queryCompanyCode: '',
      queryDataMonth: '',
      companyData: null,
      queryErrorMessage: '',

      newCompany: {
        CompanyCode: '',
        CompanyName: '',
        Industry: '',
        DataMonth: '',
        RevenueCurrentMonth: 0,
        RevenueLastMonth: 0,
        RevenueSameMonthLastYear: 0,
        RevenueChangeLastMonth: 0,
        RevenueChangeLastYear: 0,
        CumulativeRevenueCurrentYear: 0,
        CumulativeRevenueLastYear: 0,
        CumulativeRevenueChange: 0,
        Remarks: '',
        ReportDate: ''
      },
      addErrorMessage: '',
      addSuccessMessage: ''
    };
  },
  methods: {
    async getCompanyData() {
      try {
        const response = await fetch(
          `https://localhost:7009/api/Home/${this.queryCompanyCode}/${this.queryDataMonth}`
        );
        if (!response.ok) {
          throw new Error('查詢失敗，請檢查輸入參數');
        }
        this.companyData = await response.json();
        this.queryErrorMessage = '';
      } catch (error) {
        this.queryErrorMessage = error.message;
        this.companyData = null;
      }
    },
    async addCompanyData() {
      try {
          const response = await fetch('https://localhost:7009/api/Home', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(this.newCompany),
        });

        if (!response.ok) {
          throw new Error('新增失敗');
        }

        this.addSuccessMessage = '公司數據已成功新增';
        this.addErrorMessage = '';
        this.clearForm();
      } catch (error) {
        this.addErrorMessage = error.message;
        this.addSuccessMessage = '';
      }
    },
    clearForm() {
      this.newCompany = {
        CompanyCode: '',
        CompanyName: '',
        Industry: '',
        DataMonth: '',
        RevenueCurrentMonth: 0,
        RevenueLastMonth: 0,
        RevenueSameMonthLastYear: 0,
        RevenueChangeLastMonth: 0,
        RevenueChangeLastYear: 0,
        CumulativeRevenueCurrentYear: 0,
        CumulativeRevenueLastYear: 0,
        CumulativeRevenueChange: 0,
        Remarks: '',
        ReportDate: ''
      };
    }
  }
};
</script>

<style scoped>
    form {
        margin-bottom: 20px;
    }

        form label {
            display: block;
            margin-top: 10px;
        }

    button {
        margin-top: 20px;
    }
</style>
