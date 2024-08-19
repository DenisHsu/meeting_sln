<template>
    <div>
        <h1>公司數據管理</h1>

        <section>
            <h2>查詢公司數據</h2>
            <form @submit.prevent="getCompanyData">
                <label for="queryCompanyCode">公司代號:</label>
                <input type="text" id="queryCompanyCode" v-model="queryCompanyCode" required />

                <label for="queryDataMonth">
                    資料月份
                </label>
            </form>
        </section>
    </div>
</template>
