import api from '@/services/api'

export function useOvertimeApi(state, computed) {
    const loadInitialData = async () => {
        try {
            state.loading.value = true
            const [projectsResponse, employeesResponse] = await Promise.all([
                api.getProjects(),
                api.getEmployees()
            ])

            state.projects.value = projectsResponse.data
            state.employees.value = employeesResponse.data
            state.selectedDate.value = state.today
        } catch (error) {
            state.error.value = 'Failed to load projects'
            console.error('Error:', error)
        } finally {
            state.loading.value = false
        }
    }

    const resetForm = (clearEmployee = true) => {
        if (clearEmployee) {
            state.selectedEmployees.value = ''
        }
        state.isHoliday.value = false
        state.selectedProjects.value = ''
        state.timeStart.value = '17:20'
        state.timeEnd.value = '18:20'
        state.hasBreak.value = false
        state.timeBreakStart.value = ''
        state.timeBreakEnd.value = ''
        state.overtimeReason.value = ''

    }
    const formatTime = (time) => {
        if (!time || time.trim() === '') return null
        // Add validation logging
        //console.log('Formatting time:', time)
        // Ensure correct time format HH:MM
        const [hours, minutes] = time.split(':')
        return `${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`
    }

    const submitOvertimeRequest = async (validateForm, totalHours, totalBreakHours, retries = 3) => {
        try {
            state.submitting.value = true

            const validationError = validateForm()
            if (validationError) {
                console.error(validationError)
                return
            }

            const overtimeData = {
                employee: Number(state.selectedEmployees.value),
                employee_name: state.employees.value.find(emp => emp.id === Number(state.selectedEmployees.value))?.name || '',
                project: Number(state.selectedProjects.value),
                project_name: state.projects.value.find(proj => proj.id === Number(state.selectedProjects.value))?.name || '',
                request_date: state.selectedDate.value,
                time_start: formatTime(state.timeStart.value),
                time_end: formatTime(state.timeEnd.value),
                is_holiday: state.isHoliday.value,
                has_break: Boolean(state.hasBreak.value),
                break_start: state.hasBreak.value ? formatTime(state.timeBreakStart.value) : null,
                break_end: state.hasBreak.value ? formatTime(state.timeBreakEnd.value) : null,
                reason: state.overtimeReason.value,
                detail: state.overtimeDetail.value,
                total_hours: totalHours || 0,
                break_hours: state.hasBreak.value ? (totalBreakHours || 0) : 0,
            }
            console.log('Overtime Data:', overtimeData) // Debug log

            try {
                const existingRequest = await api.checkExistingOvertimeRequest(
                    state.selectedEmployees.value,
                    state.selectedDate.value
                )

                if (existingRequest.data.length > 0) {
                    const existingId = existingRequest.data[0].id
                    await api.updateOvertimeRequest(existingId, overtimeData)
                } else {
                    await api.createOvertimeRequest(overtimeData)
                }

                await checkExistingRequest(state.selectedEmployees.value, state.selectedDate.value)

                // Export JSON after successful submission
                try {
                    await api.exportOvertimeJson(state.selectedDate.value)
                } catch (exportError) {
                    console.error('Failed to export JSON:', exportError)
                }

            } catch (error) {
                if (error.response?.status === 409 && retries > 0) {
                    await new Promise(resolve => setTimeout(resolve, 1000))
                    return submitOvertimeRequest(validateForm, totalHours, totalBreakHours, retries - 1)
                }
                throw error
            }
        } catch (error) {
            console.error('Submission error:', error)
            const errorMessage = error.response?.data || error.message
            if (typeof errorMessage === 'object') {
                const messages = Object.entries(errorMessage)
                    .map(([field, errors]) => `${field}: ${errors.join(', ')}`)
                    .join('\n')
                console.error(messages)
            } else {
                console.error(errorMessage)
            }
        } finally {
            state.submitting.value = false
        }
    }

    const checkExistingRequest = async (employeeId, date) => {
        if (!employeeId || !date) {
            state.hasExistingRequest.value = false
            return
        }

        try {
            const existingRequest = await api.checkExistingOvertimeRequest(
                employeeId,
                date
            )

            state.hasExistingRequest.value = existingRequest.data.length > 0

            if (existingRequest.data.length > 0) {
                const request = existingRequest.data[0]
                state.selectedProjects.value = request.project
                state.timeStart.value = request.time_start.slice(0, 5)
                state.timeEnd.value = request.time_end.slice(0, 5)
                state.hasBreak.value = Boolean(request.has_break)
                if (request.has_break && request.break_start && request.break_end) {
                    state.timeBreakStart.value = request.break_start.slice(0, 5)
                    state.timeBreakEnd.value = request.break_end.slice(0, 5)
                }
                state.overtimeReason.value = request.reason
                state.overtimeDetail.value = request.detail
                state.isHoliday.value = request.is_holiday
            } else {
                resetForm(false)
            }
        } catch (error) {
            console.error('Error checking request:', error)
        }
    }

    const deleteOvertimeRequest = async (retries = 3) => {
        if (!confirm('Are you sure you want to delete this request?')) return

        try {
            state.deleting.value = true
            const existingRequest = await api.checkExistingOvertimeRequest(
                state.selectedEmployees.value,
                state.selectedDate.value
            )

            if (existingRequest.data.length > 0) {
                try {
                    const existingId = existingRequest.data[0].id
                    await api.deleteOvertimeRequest(existingId)

                    // Check if any requests remain for this date
                    const remainingRequests = await api.checkExistingOvertimeRequest(
                        null,  // Check all employees
                        state.selectedDate.value
                    )

                    if (remainingRequests.data.length > 0) {
                        // If requests remain, regenerate files
                        await api.exportOvertimeJson(state.selectedDate.value)
                    }

                    console.log('Overtime request and files updated successfully')
                    resetForm(false)
                    state.hasExistingRequest.value = false
                } catch (error) {
                    if (error.response?.status === 409 && retries > 0) {
                        await new Promise(resolve => setTimeout(resolve, 1000))
                        return deleteOvertimeRequest(retries - 1)
                    }
                    throw error
                }
            }
        } catch (error) {
            console.error('Delete failed:', error)
        } finally {
            state.deleting.value = false
        }
    }

    const handleExport = async () => {
        try {
            const response = await api.exportFiles(state.selectedDate.value);
            console.log('Files exported:', response.data);
        } catch (error) {
            console.error('Export failed:', error);
        }
    };

    return {
        loadInitialData,
        submitOvertimeRequest,
        checkExistingRequest,
        deleteOvertimeRequest,
        handleExport,
        resetForm
    }
}