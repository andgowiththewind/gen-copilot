package com.dororo.future.gencopilot.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;


@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DbTableAndColumnReqDTO {
    @NotBlank(message = "url不能为空")
    private String url;
    @NotBlank(message = "数据源账号不能为空")
    private String username;
    @NotBlank(message = "数据源密码不能为空")
    private String password;
    @NotBlank(message = "库名不能为空")
    private String tableSchema;
    @NotBlank(message = "表名不能为空")
    private String tableName;
}
