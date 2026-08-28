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
