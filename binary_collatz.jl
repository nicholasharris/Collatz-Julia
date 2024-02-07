#does the collatz procedure on binary strings

using Dates

function count_ones(s)
    count = 0
    for i ∈ s
        if i == '1'
            count += 1
        end
    end
    return count
end

function remove_trailing_zeros(s)
    num_removed = 0
    while s[end] == '0'
        s = chop(s)
        num_removed += 1
    end

    return s, num_removed
end

function append_one_on_right(s)
    new_string = s*"1"
    return new_string
end

function last_digit(s)
    if s == ""
        return '0'
    else 
        return s[end]
    end
end

function add_binary_strings(s1, s2)
    carry = '0'
    sum = ""

    while s1 != "" || s2 != "" || carry == '1'
        digsum, carry = add_binary_digits(last_digit(s1), last_digit(s2), carry)
        sum = digsum * sum
        s1 = chop(s1)
        s2 = chop(s2)
    end

    return sum
end

function add_binary_digits(d1, d2, carry)
    sum = '0'
    new_carry = '0'

    num_ones = count_ones(d1*d2*carry)

    if num_ones == 0
        sum = '0'
        new_carry = '0'
    elseif num_ones == 1
        sum = '1'
        new_carry = '0'
    elseif num_ones == 2
        sum = '0'
        new_carry = '1'
    elseif num_ones == 3
        sum = '1'
        new_carry = '1'
    end

    return sum, new_carry
end

function compare_digits(a, b)
    if a == b
        return 0
    elseif a == '0' && b == '1'
        return -1
    elseif a == '1' && b == '0'
        return 1
    end
end

#compares 2 binary strings to see if a < b
function is_less(a, b)
    if length(a) > length(b)
        return false
    elseif length(a) < length(b)
        return true
    end

    for i ∈ eachindex(a)
        if compare_digits(a[i], b[i]) == -1  # if a < b
            return true
        elseif compare_digits(a[i], b[i]) == 1 # if a > b
            return false
        end   
    end

    return false
end

function collatz_verbose(n)
    steps = 0

    println("START: $n")

    loop_counter = 0
    while true
        # remove trailing zeros (equivalent to repeatedly dividing by 2 until n is odd)
        new_n, num_steps = remove_trailing_zeros(n)
        n = new_n
        steps += num_steps

        if loop_counter % 1000 == 0
            println("steps: $steps, time_stamp: $(now())")
        end

        if n == "1"
            println("1 reached. Total stopping time: $steps")
            return steps
        end

        # n -> 3n+1  (achieved by adding n + (2n + 1))
        two_n_plus_1 = append_one_on_right(n)
        n = add_binary_strings(n, two_n_plus_1)
        steps += 1

        loop_counter += 1
    end
end

#gets the total stopping time of collatz(n), i.e. until it reaches 1
function collatz_total(n)
    steps = 0

    while true
        # remove trailing zeros (equivalent to repeatedly doing n -> n/2 until n is odd)
        new_n, num_steps = remove_trailing_zeros(n)
        n = new_n
        steps += num_steps

        if n == "1"
            return steps
        end

        # n -> 3n+1  (achieved by adding n + (2n + 1))
        two_n_plus_1 = append_one_on_right(n)
        n = add_binary_strings(n, two_n_plus_1)
        steps += 1

    end
end

# perfoms collatz(n) until a value is reached lower than the initial value
function collatz(n)
    steps = 0
    start = n

    while true
        # remove trailing zeros (equivalent to repeatedly doing n -> n/2 until n is odd)
        new_n, num_steps = remove_trailing_zeros(n)
        n = new_n
        steps += num_steps

        if is_less(n, start)
            return steps
        end

        # n -> 3n+1  (achieved by adding n + (2n + 1))
        two_n_plus_1 = append_one_on_right(n)
        n = add_binary_strings(n, two_n_plus_1)
        steps += 1

    end
end

function collatz_exhaustive_search_total()
    n = "1"
    len = 1
    iostream = open("collatz_results_total.txt", "a")

    while true
        total_stopping_time = collatz_total(n)
        write(iostream, "$n,$(length(n)),$total_stopping_time\n")

        n = add_binary_strings(n, "1")

        new_length = length(n)
        if new_length > len
            println("reached $new_length digits (all numbers under 2^$(new_length - 1) checked). Time stamp: $(now())")
            len = new_length
        end
    end
end

function collatz_exhaustive_search()
    n = "10"
    len = 2
    iostream = open("collatz_results.txt", "a")

    while true
        stopping_time = collatz(n)
        write(iostream, "$n,$(length(n)),$stopping_time\n")

        n = add_binary_strings(n, "1")
        
        new_length = length(n)
        if new_length > len
            println("reached $new_length digits (all numbers under 2^$(new_length - 1) checked). Time stamp: $(now())")
            len = new_length
        end
            
    end
end

#collatz_exhaustive_search()
#collatz_exhaustive_search_total()

#test convergence for a randomly generated very large number
big_string = "1"
for i ∈ 1:10000
    global big_string
    if rand() < 0.5
        big_string = big_string*'0'
    else
        big_string = big_string*'1'
    end
end 

collatz_verbose(big_string)