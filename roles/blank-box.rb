name 'blank-box'
description 'for creating blank boxes on demand for whatever you need to do'
run_list(
  'role[wistia-base]',
  'recipe[getting-started]'
)
