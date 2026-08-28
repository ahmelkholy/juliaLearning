---
id: S08
aliases:
  - "كود تشغيل جميع الدروس"
type: source-note
status: complete
tags:
  - source/code
  - julia
source: scripts/run_all.jl
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# كود تشغيل جميع الدروس


## غرض الملف

سكربت صغير يكتشف ملفات الدروس ويرتبها ويشغّل كل واحد في process مستقلة، فيمنع تسرب الأنواع والطرق بين التجارب.

## أسئلة توجه القراءة

1. لماذا لا يعمل السكربت include لكل درس داخل process واحدة؟
2. كيف يستعمل `Base.julia_cmd()` نفس Julia النشطة؟

## الكود الكامل

```julia
# Run every lesson in a separate process. Isolation matters because lessons define
# experimental types and methods; a fresh process prevents cross-lesson state leaks.

project_root = normpath(joinpath(@__DIR__, ".."))
lesson_directory = joinpath(project_root, "lessons")
lesson_names = sort(filter(name -> occursin(r"^\d\d_.*\.jl$", name), readdir(lesson_directory)))

println("Running ", length(lesson_names), " lessons in isolated Julia processes.")

for (number, lesson_name) in enumerate(lesson_names)
    lesson_path = joinpath(lesson_directory, lesson_name)
    println("\n[", number, "/", length(lesson_names), "] ", lesson_name)
    command = `$(Base.julia_cmd()) --project=$project_root $lesson_path`
    run(command)
end

println("\nAll lessons passed. Now change one idea, observe the failure, and repair it.")
```

## روابط الفهم

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[maps/M00-julia-mastery-map.idea|M00 - خريطة إتقان Julia]]
- [[sources/S07-learning-coach-source.idea|S07 - كود مدرب التعلم]]
- [[notes/A33-include-evaluates-files-in-current-module.idea|A33 - include يقيم الملف داخل الوحدة الحالية]]
- [[notes/A35-project-and-manifest-fix-package-environment.idea|A35 - Project و Manifest يثبتان بيئة الحزمة]]

