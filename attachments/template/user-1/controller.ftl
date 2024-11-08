<#include "环境变量辅助.ftl"/>
package ${controllerPackage};

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.alibaba.excel.EasyExcel;
import com.github.pagehelper.PageInfo;
import com.zhien.common.core.controller.BaseController;
import com.zhien.common.core.domain.R;
import ${domainPackage}.${domainName};
import ${dtoPackage}.${domainName}AddDTO;
import ${dtoPackage}.${domainName}ExportDTO;
<#--import ${dtoPackage}.${domainName}ImportDTO;-->
import ${dtoPackage}.${domainName}PageDTO;
import ${dtoPackage}.${domainName}UpdateDTO;
import ${servicePackage}.${domainName}Service;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

/**
 * `${domainChineseDescription}`控制器
 *
 * @author ${author!}
 * @date ${dateTime!}
 */
@RestController
@Api(tags = "${domainChineseDescription}")
@RequestMapping("/${domainName?uncap_first}")
public class ${domainName}Controller extends BaseController {
    /**
     * 服务对象
     */
    @Autowired
    private ${domainName}Service ${domainName?uncap_first}Service;

    @PostMapping("/add")
    @ApiOperation(value = "add", notes = "新增")
    public R add(@RequestBody @Validated ${domainName}AddDTO addDTO) {
        ${domainName?uncap_first}Service.add(addDTO);
        return R.ok();
    }

    @PostMapping("/delete/{id}")
    @ApiOperation(value = "delete", notes = "删除")
    public R delete(@PathVariable(value = "id") Integer id) {
        ${domainName?uncap_first}Service.deleteByPrimaryKey(id);
        return R.ok();
    }

    @PostMapping("/update")
    @ApiOperation(value = "update", notes = "更新")
    public R update(@RequestBody @Validated ${domainName}UpdateDTO updateDTO) {
        ${domainName?uncap_first}Service.update(updateDTO);
        return R.ok();
    }

    @PostMapping("/get/{id}")
    @ApiOperation(value = "get", notes = "查询")
    public R get(@PathVariable(value = "id") Integer id) {
        ${domainName} ${domainName?uncap_first} = ${domainName?uncap_first}Service.selectByPrimaryKey(id);
        return R.data(${domainName?uncap_first});
    }

    @PostMapping("/page")
    @ApiOperation(value = "page", notes = "条件分页查询")
    public R page(@RequestBody @Validated ${domainName}PageDTO pageDTO) {
        // pageDTO.setIsDelete(YesNoEnum.NO.value + "");
        startPage();
        List<${domainName}ExportDTO> list = ${domainName?uncap_first}Service.conditionalQueryPage(pageDTO);
        PageInfo pageInfo = new PageInfo(list);
        return R.page(pageInfo.getTotal(), pageInfo.getPageSize(), pageInfo.getPageNum(), pageInfo.getList());
    }

    /**
     * 导出失败时反馈JSON
     */
    @PostMapping("/export")
    @ApiOperation(value = "export", notes = "导出")
    public void export(@RequestBody @Validated ${domainName}PageDTO pageDTO, HttpServletResponse response) throws IOException {
        // pageDTO.setIsDelete(YesNoEnum.NO.value + "");
        List<${domainName}ExportDTO> list = ${domainName?uncap_first}Service.conditionalQueryAllPage(pageDTO);
        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("utf-8");
            String businessName = StrUtil.format("{}_{}", "${domainChineseDescription}", DateUtil.format(DateUtil.date(), "yyyyMMdd_HHmmss"));
            String fileName = URLEncoder.encode(businessName, "UTF-8").replaceAll("\\+", "%20");
            response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
            EasyExcel.write(response.getOutputStream(), ${domainName}ExportDTO.class).autoCloseStream(Boolean.FALSE).sheet("data").doWrite(list);
        } catch (Exception e) {
            response.reset();
            response.setContentType("application/json");
            response.setCharacterEncoding("utf-8");
            R error = R.error("下载文件失败" + e.getMessage());
            response.getWriter().println(JSONUtil.toJsonStr(error));
        }
    }

    @PostMapping("/import")
    @ApiOperation(value = "import", notes = "导入")
    public R importExcel(@RequestParam("file") MultipartFile[] files) throws Exception {
        return R.data(${domainName?uncap_first}Service.importExcel(files));
    }
}
