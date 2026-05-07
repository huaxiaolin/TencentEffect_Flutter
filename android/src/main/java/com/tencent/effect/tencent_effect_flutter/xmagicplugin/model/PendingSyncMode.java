package com.tencent.effect.tencent_effect_flutter.xmagicplugin.model;

/**
 * 待设置的syncMode数据模型
 */
public class PendingSyncMode {
    public final boolean isSync;
    public final int syncFrameCount;

    public PendingSyncMode(boolean isSync, int syncFrameCount) {
        this.isSync = isSync;
        this.syncFrameCount = syncFrameCount;
    }
}
