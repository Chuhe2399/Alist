#!/system/bin/sh

# 等待系统启动完成
until [ "$(getprop init.svc.bootanim)" = "stopped" ]; do
    sleep 5
done

# 变量定义
service_path=$(realpath "$0")
module_dir=$(dirname "$service_path")
alist_data_dir="/data/alist"
alist_bin="${module_dir}/system/bin/alist"
alist_log="${alist_data_dir}/run.log"

# 创建 alist 数据目录（如果不存在）
mkdir -p "${alist_data_dir}"

# 清理旧日志（如有）
rm -f "${alist_log}"

# 启动 alist 服务
nohup "${alist_bin}" server --data "${alist_data_dir}" > "${alist_log}" 2>&1 &

# 检查是否启动成功
sleep 2
if pgrep -f "${alist_bin}" > /dev/null; then
    echo "[Alist] 启动成功，日志位置：${alist_log}"
else
    echo "[Alist] 启动失败，请查看日志：${alist_log}"
fi