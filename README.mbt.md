# `bobzhang/dot`

A lightweight MoonBit library for building and visualizing directed graphs. Generate both Graphviz DOT format and Mermaid flowcharts from the same graph structure.

## Features

- 🎨 **Dual Output Formats**: Export to DOT (Graphviz) or Mermaid flowcharts
- 🎭 **Flexible Styling**: Customize node shapes, colors, and edge styles
- 🔄 **Bidirectional Edges**: Support for bidirectional relationships
- 📦 **Subgraphs/Clusters**: Group related nodes together
- 🧩 **Simple API**: Fluent interface with method chaining
- 🔤 **Unicode Support**: Handles special characters and Unicode labels
- 📐 **Configurable Layout**: Control graph direction (LR, TB, BT, RL)

## Installation

```bash
moon add bobzhang/dot
```

## Quick Start

### Basic Graph (DOT Format)

```mbt check
///|
test "dot: quickstart" {
  let builder = @flowgraph.DotBuilder::new()
  builder
  ..add_node(id="a", label="Start")
  ..add_node(id="b", label="End")
  ..add_edge(src="a", dst="b", label="→")
  inspect(
    builder.to_dot(),
    content=(
      #|digraph Marshal {
      #|  rankdir=LR;
      #|  node [shape=box, style=rounded];
      #|
      #|  a [label="Start"];
      #|  b [label="End"];
      #|
      #|  a -> b [label="→"];
      #|}
      #|
    ),
  )
}
```

### Basic Graph (Mermaid Format)

```mbt check
///|
test "quickstart-mermaid" (it : @test.Test) {
  let builder = @flowgraph.DotBuilder::new()
  builder
  ..add_node(id="a", label="Start")
  ..add_node(id="b", label="End")
  ..add_edge(src="a", dst="b", label="→")
  let got = builder.to_mermaid()
  inspect(
    got,
    content=(
      #|flowchart LR
      #|%% graph: Marshal
      #|
      #|  a["Start"]
      #|  b["End"]
      #|
      #|  a -->|→| b
      #|
    ),
  )
  it.write(got)
  it.snapshot(filename="\{it.name()}.mmd")
}
```

[View rendered output](./__snapshot__/quickstart-mermaid.mmd)

## Advanced Usage

### Custom Graph Direction and Styling

Control graph direction and add custom styling to nodes and edges:

```mbt
///|
test "styled graph example" {
  let builder = @flowgraph.DotBuilder::with_config(
    graph_name="Workflow",
    rankdir="TB", // Top to Bottom
  )
  builder
  ..add_node(id="start", label="Start", shape="circle", color="green")
  ..add_node(id="process", label="Process", shape="box", color="lightblue")
  ..add_node(id="end", label="End", shape="doublecircle", color="red")
  ..add_edge(
    src="start",
    dst="process",
    label="begin",
    style="solid",
    color="black",
  )
  ..add_edge(
    src="process",
    dst="end",
    label="complete",
    style="dashed",
    color="blue",
  )
}
```

**Supported directions**: `LR` (left-right), `TB` (top-bottom), `BT` (bottom-top), `RL` (right-left)

**Node shapes**: `box`, `circle`, `ellipse`, `diamond`, `doublecircle`, and more

**Edge styles**: `solid`, `dashed`, `dotted`, `bold`

### Bidirectional Edges

```mbt
///|
test "bidirectional example" {
  let builder = @flowgraph.DotBuilder::new()
  builder
  ..add_node(id="client", label="Client")
  ..add_node(id="server", label="Server")
  ..add_bidirectional_edge(node1="client", node2="server", label="HTTP")
}
```

### Subgraphs (Clusters)

Group related nodes into visual clusters:

```mbt
///|
test "subgraph example" {
  let builder = @flowgraph.DotBuilder::new()
  builder
  ..add_node(id="web1", label="Web Server 1")
  ..add_node(id="web2", label="Web Server 2")
  ..add_node(id="app1", label="App Server 1")
  ..add_node(id="app2", label="App Server 2")
  ..add_subgraph(name="frontend", label="Frontend Tier", nodes=["web1", "web2"])
  ..add_subgraph(name="backend", label="Backend Tier", nodes=["app1", "app2"])
  ..add_edge(src="web1", dst="app1", label="")
  ..add_edge(src="web2", dst="app2", label="")
}
```

### Unique Node IDs

Generate unique node identifiers automatically:

```mbt
///|
test "auto-generated ids" {
  let builder = @flowgraph.DotBuilder::new()
  let id1 = builder.fresh_id() // "n0"
  let id2 = builder.fresh_id() // "n1"
  let id3 = builder.fresh_id() // "n2"
  builder
  ..add_node(id=id1, label="First")
  ..add_node(id=id2, label="Second")
  ..add_node(id=id3, label="Third")
}
```

## API Reference

### DotBuilder

#### Construction

- `DotBuilder::new() -> DotBuilder` - Create a new builder with default settings
- `DotBuilder::with_config(graph_name~, rankdir~) -> DotBuilder` - Create with custom configuration

#### Node Methods

- `add_node(id~, label~, shape?, color?)` - Add a node (optionally with custom styling)
- `fresh_id() -> String` - Generate a unique node ID

#### Edge Methods

- `add_edge(src~, dst~, label~, style?, color?)` - Add a directed edge (optionally with custom styling)
- `add_bidirectional_edge(node1~, node2~, label~)` - Add a bidirectional edge

#### Subgraph Methods

- `add_subgraph(name~, label~, nodes~)` - Add a subgraph cluster

#### Output Methods

- `to_dot() -> String` - Generate Graphviz DOT format
- `to_mermaid() -> String` - Generate Mermaid flowchart format

#### Configuration Methods

- `set_node_shape(shape)` - Set default node shape
- `set_node_style(style)` - Set default node style

## Use Cases

- **Dependency Graphs**: Visualize package or module dependencies
- **State Machines**: Represent state transitions
- **Flowcharts**: Create process flow diagrams
- **Network Topology**: Map network connections
- **Data Flow Diagrams**: Show data transformation pipelines
- **Call Graphs**: Visualize function call relationships
- **Architecture Diagrams**: Document system architecture

## Examples

See the test files for more examples:
- [`builder_test.mbt`](./builder_test.mbt) - Basic graph patterns
- [`advanced_test.mbt`](./advanced_test.mbt) - Advanced styling and features
- [`mermaid_test.mbt`](./mermaid_test.mbt) - Mermaid-specific examples

## License

Apache-2.0

## Links

- [Repository](https://github.com/moonbit-community/dot)
- [MoonBit Package Registry](https://mooncakes.io/packages/bobzhang/dot/)
- [Graphviz Documentation](https://graphviz.org/documentation/)
- [Mermaid Documentation](https://mermaid.js.org/)
