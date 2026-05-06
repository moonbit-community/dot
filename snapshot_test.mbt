///|
fn snapshot_filename(name : String, ext : String) -> String {
  name
  .replace_all(old=" ", new="_")
  .replace_all(old=":", new="_")
  .replace_all(old="(", new="_")
  .replace_all(old=")", new="_") +
  ext
}

///|
test "snapshot filename replaces forbidden chars" {
  inspect(snapshot_filename("a b:c(d)", ".txt"), content="a_b_c_d_.txt")
}
