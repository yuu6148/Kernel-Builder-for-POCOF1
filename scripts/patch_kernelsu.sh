#!/bin/bash
set -e

# カーネルソースのルートディレクトリにいることを前提
PATCH_FILE=ksu-compat.patch

cat > $PATCH_FILE <<'EOF'
diff --git a/drivers/kernelsu/core_hook.c b/drivers/kernelsu/core_hook.c
--- a/drivers/kernelsu/core_hook.c
+++ b/drivers/kernelsu/core_hook.c
@@ -11,6 +11,12 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,9,0)
+static inline int path_umount(struct path *path, int flags)
+{
+    return do_umount(path->mnt, flags, 0);
+}
+#endif
 EOF

git apply $PATCH_FILE
