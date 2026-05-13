# 布局系统参考

OpenTUI 使用 Yoga 布局引擎提供 CSS Flexbox 能力。

## Flex 方向

```typescript
{ flexDirection: "column" }       // 垂直（默认）
{ flexDirection: "row" }          // 水平
{ flexDirection: "row-reverse" }
{ flexDirection: "column-reverse" }
```

## 主轴对齐 (JustifyContent)

```typescript
{
  justifyContent: "flex-start"    // 起始对齐
  justifyContent: "flex-end"      // 末尾对齐
  justifyContent: "center"        // 居中
  justifyContent: "space-between" // 均匀分布（无边缘间距）
  justifyContent: "space-around"  // 均匀分布（有边缘间距）
  justifyContent: "space-evenly"  // 真正均匀分布
}
```

## 交叉轴对齐 (AlignItems)

```typescript
{
  alignItems: "flex-start"  // 起始对齐
  alignItems: "flex-end"    // 末尾对齐
  alignItems: "center"      // 居中
  alignItems: "stretch"     // 拉伸填充（默认）
  alignItems: "baseline"    // 基线对齐
}
```

## 尺寸设置

### 固定尺寸
```typescript
{ width: 30, height: 10 }
```

### 百分比
```typescript
{ width: "100%", height: "50%" }
```

### Flex 伸缩
```typescript
{ flexGrow: 1, flexShrink: 0, flexBasis: 100 }
```

## 定位

### 相对（默认）
```typescript
{ position: "relative" }
```

### 绝对
```typescript
{ position: "absolute", left: 10, top: 5, right: 10, bottom: 5 }
```

## 内边距和边距

```typescript
{
  padding: 2,         // 统一
  paddingX: 4,        // 水平
  paddingY: 2,        // 垂直
  paddingTop: 1,      // 单个方向
  paddingRight: 2,
  paddingBottom: 1,
  paddingLeft: 2,
  margin: 1,          // 相同模式
  marginX: 3,
  marginY: 1,
}
```

## 使用 Constructs

```typescript
renderer.root.add(
  Box(
    { flexDirection: "row", width: "100%", height: 10 },
    Box({ flexGrow: 1, backgroundColor: "#333", padding: 1 },
      Text({ content: "Left Panel" }),
    ),
    Box({ width: 20, backgroundColor: "#555", padding: 1 },
      Text({ content: "Right Panel" }),
    ),
  ),
)
```

## 响应式布局

```typescript
renderer.on("resize", (width, height) => {
  if (width < 80) {
    container.flexDirection = "column"
  } else {
    container.flexDirection = "row"
  }
})
```
