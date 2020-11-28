class SeatingsController < ApplicationController

  def new
  end

  def create
    input_details = params[:seating]
    noc = input_details["noc"].to_i
    comDif = input_details["comDif"].split(',')
    pc = input_details["pc"].to_i
    puts comDif.length
    puts 2*noc
    if comDif.length < 2*noc
      message = "The seating arrangements given doesn't match! Kindly check and try again"
      render plain: message
      return
    end
    @filled_seats = fillSeat(noc, comDif , pc)
    render :show
  end

  def fillSeat(num_of_compartment, compartment_differentiation, passenger_count)
    @max_row = 0
    comp_diff_index = 0
    all_compartments = Array.new(num_of_compartment)
    all_compartments.each_with_index do |compartment, index|
      comp_width = compartment_differentiation[comp_diff_index].to_i
      if comp_width > @max_row
        @max_row = comp_width
      end
      comp_height = compartment_differentiation[comp_diff_index + 1].to_i
      compartment = Array.new(comp_height){Array.new(comp_width, 0)}
      all_compartments[index] = compartment
      comp_diff_index = comp_diff_index + 2
    end
    seat_filled = 1
    current_compartment_index = 0
    fill_window = false
    end_of_comp = true
    temp_comp = all_compartments[current_compartment_index]
    temp_row = 0
    temp_col = temp_comp[temp_row].length - 1
    while(seat_filled <= passenger_count) do
      unless fill_window
        current_compartment = all_compartments[current_compartment_index]
        current_compartment[temp_row][temp_col] = seat_filled
        all_compartments[current_compartment_index] = current_compartment
        seat_filled = seat_filled + 1
        if end_of_comp
          current_compartment_index = current_compartment_index + 1
          temp_col = 0
          end_of_comp = false
        else
          if current_compartment_index == all_compartments.length - 1
            current_compartment_index = 0
            temp_row = temp_row + 1
          end
          current_compartment = all_compartments[current_compartment_index]
          temp_col = current_compartment[0].length - 1
          end_of_comp = true
        end
        if temp_row > @max_row - 1
          temp_row = 0
          current_compartment_index = 0
          last_complartment_index = all_compartments.length - 1
          fill_window = true
        end
        current_compartment = all_compartments[current_compartment_index]
        if temp_row >= current_compartment.length
          end_of_comp = !end_of_comp
        end
        while temp_row >= current_compartment.length do
          if current_compartment_index == all_compartments.length - 1
            current_compartment_index = 0
            temp_row = temp_row + 1
          else
            current_compartment_index = current_compartment_index + 1
            temp_col = 0
          end
          current_compartment = all_compartments[current_compartment_index]
        end
      else
        current_compartment = all_compartments[current_compartment_index]
        if temp_row < current_compartment.length
          current_compartment[temp_row][0] = seat_filled
          seat_filled = seat_filled + 1
        end
        current_compartment = all_compartments[last_complartment_index]
        if temp_row < current_compartment.length
          current_compartment[temp_row][current_compartment[0].length - 1] = seat_filled
          seat_filled = seat_filled + 1
        end
        temp_row = temp_row + 1
        if temp_row > @max_row - 1
          break
        end
      end
    end

    for i in 0..@max_row - 1
      for j in 0..all_compartments.length - 1
        current_comp = all_compartments[j]
        for k in 0..current_comp[0].length - 1
          if i >= current_comp.length || seat_filled > passenger_count
            break
          end
          if current_comp[i][k] == 0
            current_comp[i][k] = seat_filled
            seat_filled = seat_filled + 1
          end
        end
      end
    end
    return all_compartments
  end
end
