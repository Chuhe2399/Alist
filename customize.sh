SKIPUNZIP=1

# 变量定义
alist_data_dir="/data/alist"
modules_dir="/data/adb/modules"
system_gid="1000"
system_uid="1000"

ui_print "- 初始化模块安装..."

# 架构判断
case "${ARCH}" in
    arm)   arch_folder="armv7"  ;;
    arm64) arch_folder="arm64" ;;
    x86)   arch_folder="386"   ;;
    x64)   arch_folder="amd64" ;;
    *)
        ui_print "! 错误：不支持的架构 ${ARCH}"
        abort
        ;;
esac

# 创建所需目录
ui_print "- 创建所需目录..."
mkdir -p "${MODPATH}/system/bin"
mkdir -p "${alist_data_dir}"

# 解压模块内容（排除 META-INF）
ui_print "- 解压模块文件..."
unzip -o "${ZIPFILE}" -x 'META-INF/*' -d "$MODPATH" >&2


# 安装二进制文件
ui_print "- 安装 alist 可执行文件..."
if [ -d "${MODPATH}/binary/${arch_folder}" ]; then
    mv -f "${MODPATH}/binary/${arch_folder}/"* "${MODPATH}/system/bin/"
else
    ui_print "! 错误：未找到对应架构的二进制文件 (${arch_folder})"
    abort
fi

# 清理无用文件夹
rm -rf "${MODPATH}/binary"

# 权限设置
ui_print "- 设置权限..."
set_perm_recursive "${MODPATH}" 0 0 0755 0644
set_perm_recursive "${alist_data_dir}" "${system_uid}" "${system_gid}" 0755 0644
set_perm "${MODPATH}/system/bin/alist" "${system_uid}" "${system_gid}" 0755  # 更安全

ui_print "- 安装完成！"
ui_print "- 用户密码请查看日志：/data/alist/run.log"