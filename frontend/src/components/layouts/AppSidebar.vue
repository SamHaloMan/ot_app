<script setup>
import { RouterLink } from 'vue-router'
import { AppSidebarNav } from '@/components/layouts/AppSidebarNav.js'
import { useSidebarStore } from '@/themes/sidebar.js'

const sidebar = useSidebarStore()
</script>

<template>
  <CSidebar class="border-end" colorScheme="dark" position="fixed" :unfoldable="sidebar.unfoldable"
    :visible="sidebar.visible" @visible-change="(value) => sidebar.toggleVisible(value)">
    <CSidebarHeader class="border-bottom">
      <RouterLink custom to="/" v-slot="{ href, navigate }">
        <CSidebarBrand v-bind="$attrs" as="a" :href="href" @click="navigate">
          <div class="sidebar-brand-content">
            <img
              src="https://media.licdn.com/dms/image/v2/D560BAQHJDTur43yGmg/company-logo_200_200/company-logo_200_200/0/1707123906642/pegatron_logo?e=2147483647&v=beta&t=o02wcI4dc5xlhG07SbkJ4aNY-TdwrWrQqgcbD0329i8"
              alt="Pegatron Logo" height="50" class="sidebar-brand-icon" />
            <span v-if="!sidebar.unfoldable" class="sidebar-brand-text">PTB AST1</span>
          </div>
        </CSidebarBrand>
      </RouterLink>
      <CCloseButton class="d-lg-none" dark @click="sidebar.toggleVisible()" />
    </CSidebarHeader>
    <AppSidebarNav />
    <CSidebarFooter class="border-top d-none d-lg-flex">
      <CSidebarToggler @click="sidebar.toggleUnfoldable()" />
    </CSidebarFooter>
  </CSidebar>
</template>

<style scoped>
.sidebar-brand-content {
  display: flex;
  align-items: center;
  gap: 25px;
}

.sidebar-brand-icon {
  height: 45px;
}

.sidebar-brand-text {
  font-size: 18px;
  font-weight: bold;
}
</style>
