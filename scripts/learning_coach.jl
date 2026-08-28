module LearningCoach

using TOML

const PROJECT_ROOT = normpath(joinpath(@__DIR__, ".."))

const QUESTS = [
    (
        title="Dispatch Detective",
        file="01_dispatch_and_types.jl",
        question="In Julia, where do methods belong?",
        choices=("A class", "A function", "A source file"),
        answer='b',
        takeaway="Functions own methods; dispatch considers the argument types.",
    ),
    (
        title="Memory Map",
        file="02_arrays_and_numerics.jl",
        question="What does a Julia view do with selected array data?",
        choices=("Shares the parent's storage", "Copies into a new array", "Converts it to a tuple"),
        answer='a',
        takeaway="A view shares storage, so a write through the view changes its parent.",
    ),
    (
        title="Compiler Whisperer",
        file="03_performance_and_inference.jl",
        question="Why can an abstract struct field slow a hot loop?",
        choices=("It disables loops", "It forces Float64", "Its concrete value type may be unknown at compile time"),
        answer='c',
        takeaway="Concrete field information helps Julia specialize the code that uses it.",
    ),
    (
        title="Interface Builder",
        file="04_interfaces_and_iteration.jl",
        question="How does a custom type gain generic Julia behavior?",
        choices=("Copy every Base function", "Implement a small required interface", "Subtype Matrix"),
        answer='b',
        takeaway="A few interface methods unlock many generic operations.",
    ),
    (
        title="Syntax Mechanic",
        file="05_metaprogramming.jl",
        question="What does esc do to caller-provided syntax in a macro?",
        choices=("Resolves it in the caller's scope", "Runs it twice", "Turns it into a String"),
        answer='a',
        takeaway="Use esc for syntax that must refer to the caller's bindings.",
    ),
    (
        title="Reproducibility Engineer",
        file="06_concurrency.jl",
        question="How should random streams be assigned for schedule-independent results?",
        choices=("One global RNG", "One RNG per physical thread", "One RNG per logical simulation"),
        answer='c',
        takeaway="Logical work owns its RNG, so thread scheduling cannot change the stream.",
    ),
    (
        title="Package Architect",
        file="07_package_architecture.jl",
        question="What is the main distinction between files and modules?",
        choices=("Both create namespaces", "Files organize code; modules organize namespaces", "Modules only store tests"),
        answer='b',
        takeaway="A file is an organization unit; a module creates a namespace boundary.",
    ),
    (
        title="Failure Designer",
        file="08_errors_resources_and_testing.jl",
        question="What does a finally block guarantee?",
        choices=("No exception can occur", "The result is cached", "Cleanup runs whether or not the body throws"),
        answer='c',
        takeaway="Use finally when cleanup must happen on both success and failure.",
    ),
    (
        title="Numerical Guardian",
        file="09_algorithm_design.jl",
        question="What can compensated summation recover?",
        choices=("Small terms lost to rounding", "Missing input elements", "Exact symbolic formulas"),
        answer='a',
        takeaway="Compensation tracks low-order information lost by ordinary floating-point addition.",
    ),
    (
        title="Scientific Finisher",
        file="10_scientific_capstone.jl",
        question="About how much should fourth-order RK4 error fall when dt is halved?",
        choices=("2 times", "16 times", "100 times"),
        answer='b',
        takeaway="Fourth-order error scales like dt^4, so halving dt gives about 2^4 = 16.",
    ),
]

progress_path() = get(
    ENV,
    "JULIA_MASTERY_PROGRESS",
    joinpath(PROJECT_ROOT, ".julia_mastery_progress.toml"),
)

function load_progress(path=progress_path())
    isfile(path) || return Set{Int}()
    data = try
        TOML.parsefile(path)
    catch error
        throw(ArgumentError("cannot read progress file $path: $(sprint(showerror, error))"))
    end
    raw_completed = get(data, "completed", Any[])
    completed = Set{Int}()
    for value in raw_completed
        value isa Integer || continue
        value in eachindex(QUESTS) && push!(completed, Int(value))
    end
    return completed
end

function save_progress(completed, path=progress_path())
    mkpath(dirname(path))
    data = Dict(
        "version" => 1,
        "completed" => sort!(collect(completed)),
    )
    open(path, "w") do io
        TOML.print(io, data)
    end
    return path
end

function parse_quest(text)
    number = tryparse(Int, text)
    isnothing(number) && throw(ArgumentError("quest must be a number from 1 to $(length(QUESTS))"))
    number in eachindex(QUESTS) ||
        throw(ArgumentError("quest must be a number from 1 to $(length(QUESTS))"))
    return number
end

function learner_rank(completed_count)
    completed_count == length(QUESTS) && return "Julia Master"
    completed_count >= 7 && return "Numerical Architect"
    completed_count >= 4 && return "Interface Builder"
    completed_count >= 1 && return "Dispatch Apprentice"
    return "New Explorer"
end

function show_status(io=stdout)
    completed = load_progress()
    count_done = length(completed)
    width = length(QUESTS)
    bar = repeat("#", count_done) * repeat("-", width - count_done)

    println(io, "Julia Mastery progress")
    println(io, "[$bar] ", count_done, "/", width, " quests  |  ", 100 * count_done, " XP")
    println(io, "Rank: ", learner_rank(count_done))
    println(io)
    for (number, quest) in enumerate(QUESTS)
        marker = number in completed ? "x" : " "
        println(io, "[", marker, "] ", lpad(number, 2), "  ", quest.title)
    end

    if count_done == width
        println(io, "\nCourse clear. Your next challenge is exercises/advanced_exercises.jl.")
    else
        next_quest = findfirst(number -> !(number in completed), eachindex(QUESTS))
        println(io, "\nNext: julia --project=. scripts/learning_coach.jl start ", next_quest)
    end
    return nothing
end

function run_quest(number, io=stdout)
    quest = QUESTS[number]
    lesson_path = joinpath(PROJECT_ROOT, "lessons", quest.file)
    println(io, "Quest ", number, ": ", quest.title)
    println(io, "Running ", relpath(lesson_path, PROJECT_ROOT), " ...\n")
    command = `$(Base.julia_cmd()) --project=$PROJECT_ROOT $lesson_path`
    try
        run(command)
    catch error
        error isa ProcessFailedException || rethrow()
        println(io, "\nThe lesson failed. Use the error as a clue, repair the code, and run it again.")
        return 1
    end
    println(io, "\nLesson passed. Lock in the idea with:")
    println(io, "julia --project=. scripts/learning_coach.jl quiz ", number)
    return 0
end

function read_answer(quest, args, io=stdout)
    println(io, quest.question)
    for (index, choice) in enumerate(quest.choices)
        letter = Char(Int('A') + index - 1)
        println(io, "  ", letter, ") ", choice)
    end
    if !isempty(args)
        return lowercase(strip(first(args)))
    end
    print(io, "Your answer: ")
    flush(io)
    return eof(stdin) ? "" : lowercase(strip(readline()))
end

function run_quiz(number, answer_args, io=stdout)
    quest = QUESTS[number]
    answer = read_answer(quest, answer_args, io)
    if length(answer) != 1 || only(answer) != quest.answer
        println(io, "Not yet. Revisit the prediction and experiment, then try again.")
        return 1
    end

    completed = load_progress()
    already_complete = number in completed
    push!(completed, number)
    save_progress(completed)
    println(io, "Correct. ", quest.takeaway)
    if already_complete
        println(io, "Quest ", number, " was already complete; your XP stays at ", 100 * length(completed), ".")
    else
        println(io, "+100 XP  |  Total: ", 100 * length(completed), " XP")
    end

    if length(completed) == length(QUESTS)
        println(io, "All ten quests complete. The advanced exercises are now your final arena.")
    else
        next_quest = findfirst(index -> !(index in completed), eachindex(QUESTS))
        println(io, "Next suggested quest: ", next_quest, " — ", QUESTS[next_quest].title)
    end
    return 0
end

function show_help(io=stdout)
    println(io, "Julia Mastery learning coach")
    println(io)
    println(io, "Commands:")
    println(io, "  status             Show progress, XP, and the next quest")
    println(io, "  next               Run the first incomplete quest")
    println(io, "  start N            Run lesson N in a clean Julia process")
    println(io, "  quiz N [A|B|C]     Answer checkpoint N and record completion")
    println(io, "  help               Show this message")
    return nothing
end

function main(args=ARGS)
    isempty(args) && (show_help(); return 0)
    command = lowercase(first(args))
    rest = args[2:end]

    try
        if command == "status"
            isempty(rest) || throw(ArgumentError("status takes no arguments"))
            show_status()
            return 0
        elseif command == "next"
            isempty(rest) || throw(ArgumentError("next takes no arguments"))
            completed = load_progress()
            next_quest = findfirst(number -> !(number in completed), eachindex(QUESTS))
            if isnothing(next_quest)
                println("All quests are complete. Open exercises/advanced_exercises.jl.")
                return 0
            end
            return run_quest(next_quest)
        elseif command == "start"
            length(rest) == 1 || throw(ArgumentError("usage: start N"))
            return run_quest(parse_quest(only(rest)))
        elseif command == "quiz"
            1 <= length(rest) <= 2 || throw(ArgumentError("usage: quiz N [A|B|C]"))
            return run_quiz(parse_quest(first(rest)), rest[2:end])
        elseif command in ("help", "-h", "--help")
            show_help()
            return 0
        end
        throw(ArgumentError("unknown command: $command"))
    catch error
        error isa ArgumentError || rethrow()
        println(stderr, "Error: ", sprint(showerror, error))
        println(stderr, "Run `julia --project=. scripts/learning_coach.jl help` for usage.")
        return 2
    end
end

abspath(PROGRAM_FILE) == abspath(@__FILE__) && exit(main())

end # module
