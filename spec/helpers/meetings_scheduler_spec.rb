require 'spec_helper'

describe MeetingsScheduler do
  describe MeetingsScheduler::Scheduler do
    describe "instance method: new" do
      it "should create an instnace object of Scheduler" do
        #@scheduler = MeetingsScheduler::Scheduler.new()  
      end 
    end
    
    describe "instance method: make_meetings" do 
    end
    
    describe "class method: create_meetings" do
    end
    
    describe "class method: need_a_new_meeting?" do 
    end
    
    describe "class method: set_up_new_meeting" do 
    end
      
    describe "class method: create_population" do 
    end    
    
  end

  describe MeetingsScheduler::GeneticAlgorithm do
    describe "class method: run" do
    end
  
    describe "class method: selection" do
      it "should select a breed population given a population of chromosomes" do
        #meeting_solution = mock("meeting_solution")
    
        #a dependency issue needs to be fixed
        #@chromosome1 = MeetingsScheduler::Chromosome.new(meeting_solution)
        #@chromosome2 = MeetingsScheduler::Chromosome.new(meeting_solution)
        #@chromosome3 = MeetingsScheduler::Chromosome.new(meeting_solution)
        #@chromosome4 = MeetingsScheduler::Chromosome.new(meeting_solution)
        
        #@chromosome1.stub(:fitness).and_return(50)
        #@chromosome2.stub(:fitness).and_return(55)
        #@chromosome3.stub(:fitness).and_return(40)
        #@chromosome4.stub(:fitness).and_return(35)
      
        #population = [@chromosome1, @chromosome2, @chromosome3, @chromosome4]
        
        
        #MeetingsScheduler::GeneticAlgorithm.stub!(:select_random_individual).and_return(@chromosome3, @chromosome1)
        #breed_population = MeetingsScheduler::GeneticAlgorithm.selection(population)
        #puts breed_population
        #breed_population.count.should == 2
        #breed_population.should == [@chromosome3, @chromosome1]
      end
    end
    
    describe "class method: reproduction" do
      it "should produce a offspring population given a parent population of chromosomes" do
        
        offspring_chromosome1 = mock("mutated_chromosome1", :fitness => 45)
        offspring_chromosome2 = mock("mutated_chromosome2", :fitness => 68)
        offspring_chromosome3 = mock("mutated_chromosome3", :fitness => 79)
        MeetingsScheduler::Chromosome.stub!(:reproduce).and_return(offspring_chromosome1, offspring_chromosome2, offspring_chromosome3)
    
        chromosome1 = mock("chromosome1", :fitness => 50)
        chromosome2 = mock("chromosome2", :fitness => 55)
        chromosome3 = mock("chromosome3", :fitness => 40)
        breed_population = [chromosome1, chromosome2, chromosome3]
      
        offsprings = MeetingsScheduler::GeneticAlgorithm.reproduction(breed_population)
        offsprings.should == [offspring_chromosome1]
      end
    end
        
    describe "class method: mutate_all_population" do
      it "should return a newly mutated population given a population of chromosomes" do
        mutated_chromosome1 = mock("mutated_chromosome1", :fitness => 45)
        mutated_chromosome2 = mock("mutated_chromosome2", :fitness => 68)
        mutated_chromosome3 = mock("mutated_chromosome3", :fitness => 79)
        MeetingsScheduler::Chromosome.stub!(:mutate).and_return(mutated_chromosome1, mutated_chromosome2, mutated_chromosome3)
        
        chromosome1 = mock("chromosome1", :fitness => 50)
        chromosome2 = mock("chromosome2", :fitness => 55)
        chromosome3 = mock("chromosome3", :fitness => 40)
        population = [chromosome1, chromosome2, chromosome3]
        
        mutated_population = MeetingsScheduler::GeneticAlgorithm.mutate_all_population(population)
        mutated_population.should == [mutated_chromosome1, mutated_chromosome2, mutated_chromosome3]
      end    
    end
    
    describe "class method: select_best_chromosome" do
      it "should select the chromosome with fitness 55 when given a population of three chromosomes with fitness 50, 55, and 40" do
        chromosome1 = mock("chromosome1", :fitness => 50)
        chromosome2 = mock("chromosome2", :fitness => 55)
        chromosome3 = mock("chromosome3", :fitness => 40)
      
        population = [chromosome1, chromosome2, chromosome3]
        best_chromosome = MeetingsScheduler::GeneticAlgorithm.select_best_chromosome(population)
        best_chromosome.fitness.should == 55
      end
    end
    
    describe "class method: replace_worst_ranked" do
      it "should replaces the less fit chromosomes in the population by the offspring chromosomes" do
        chromosome1 = mock("chromosome1", :fitness => 50)
        chromosome2 = mock("chromosome2", :fitness => 55)
        chromosome3 = mock("chromosome3", :fitness => 40)
        chromosome4 = mock("chromosome4", :fitness => 35)
  
        offspring_chromosome1 = mock("offspring_chromosome1", :fitness => 60)
        offspring_chromosome2 = mock("offspring_chromosome2", :fitness => 36)
        
        population = [chromosome1, chromosome2, chromosome3, chromosome4]
        offsprings = [offspring_chromosome1, offspring_chromosome2]
        new_population = MeetingsScheduler::GeneticAlgorithm.replace_worst_ranked(population, offsprings)
        
        new_population.should == [chromosome2, chromosome1, offspring_chromosome1, offspring_chromosome2]
      end
    end
    
    describe "class method: select_random_inidividual" do  
      it "should return a randomly selected chromosome given a population of chromosomes" do
        chromosome1 = mock("chromosome1", :fitness => 50, :normalized_fitness => 0.75)
        chromosome2 = mock("chromosome2", :fitness => 55, :normalized_fitness => 1)
        chromosome3 = mock("chromosome3", :fitness => 40, :normalized_fitness => 0.25)
        chromosome4 = mock("chromosome4", :fitness => 35, :normalized_fitness => 0)
        population = [chromosome1, chromosome2, chromosome3, chromosome4]
        accumulated_normalized_fitness = 2
        MeetingsScheduler::GeneticAlgorithm.stub!(:rand).and_return(0.687901)
        
        chromosome = MeetingsScheduler::GeneticAlgorithm.select_random_individual(population, accumulated_normalized_fitness)
        chromosome.should == chromosome2
      end
    end    
  end
   
  describe MeetingsScheduler::MockMeeting do
    before(:each) do
      faculty_id = 15
      schedule_index = 4
      admit_id = 35
      @mock_meeting = MeetingsScheduler::MockMeeting.new(faculty_id, schedule_index, admit_id)
    end
    
    describe "Meeting attributes" do         
      it "has a faculty_id getter method" do 
        @mock_meeting.should respond_to(:faculty_id) 
      end
      
      it "has a faculty_id setter method" do
        @mock_meeting.should respond_to(:faculty_id=)
      end
      
      it "has a schedule_index getter method" do 
        @mock_meeting.should respond_to(:schedule_index) 
      end
      
      it "has a schedule_index setter method" do
        @mock_meeting.should respond_to(:schedule_index=)
      end
      
      it "has an admit_id getter method" do
        @mock_meeting.should respond_to(:admit_id)
      end
      
      it "has an admit_id setter method" do 
        @mock_meeting.should respond_to(:admit_id=) 
      end
      
      it "should have faculty_id = 15, schedule_index = 4, admit_id = 35 when we created a mock_meeting with those values" do
        @mock_meeting.faculty_id.should == 15
        @mock_meeting.schedule_index.should == 4
        @mock_meeting.admit_id.should == 35 
      end 
    end
        
    describe "instance method: faculty_id=" do
      it "should set faculty_id to 25 if we call the setter method faculty_id=25" do
        @mock_meeting.faculty_id = 25
        @mock_meeting.faculty_id.should == 25
      end
    end
        
    describe "instance method: schedule_index=" do
      it "should set schedule_index to 6 if we call the setter method schedule_index=6" do
        @mock_meeting.schedule_index = 6
        @mock_meeting.schedule_index.should == 6
      end
    end
    
    describe "instance method: admit_id=" do
      it "should set admit_id to 46 if we call the setter method admit_id=46" do
        @mock_meeting.admit_id = 46
        @mock_meeting.admit_id.should == 46
      end
    end
  end
  
  describe MeetingsScheduler::MeetingSolution do
    describe "MeetingSolution attributes" do
      before(:each) do
        @meeting_solution = MeetingsScheduler::MeetingSolution.new()
      end
      
      it "has a length method" do
        @meeting_solution.should respond_to(:length)
      end
      
      it "has a add_new_mock_meeting method" do 
        @meeting_solution.should respond_to(:add_new_mock_meeting)
      end
    end
    
    describe "instance method: add_new_mock_meeting" do
      it "has a length 0 before any mock meeting has been added to the meeting solution" do
        @meeting_solution = MeetingsScheduler::MeetingSolution.new()
        puts @meeting_solution
        @meeting_solution.length.should == 0
      end
            
      it "should add a new MockMeeting object to the meeting solution and increase the length of meeting solution by 1" do
        @meeting_solution = MeetingsScheduler::MeetingSolution.new()
        @mock_meeting = MeetingsScheduler::MockMeeting.new(15, 4, 35)
        @meeting_solution.add_new_mock_meeting(@mock_meeting)
        @meeting_solution.length.should == 1
      end
    
    end
      
  end
  
  
  
  
  describe MeetingsScheduler::Chromosome do
  end
  
  
  
  
   
=begin   
  describe MeetingsScheduler::Chromosome do
    describe 'Attributes' do
      before(:each) do
        @chromosome = MeetingsScheduler::Chromosome.new([1,2,3])
      end
      
      it 'has a string of nucleotides' do
        @chromosome.should respond_to(:meeting_solution)
        @chromosome.should respond_to(:meeting_solution=)
      end

      it 'has a solution string encoding a solution' do
        @chromosome.should respond_to(:solution_string)
        @chromosome.should respond_to(:solution_string=)
      end
      
      it 'has a normalized fitness value for purposes of GA' do
        @chromosome.should respond_to(:normalized_fitness)
        @chromosome.should respond_to(:normalized_fitness=)
      end

      it 'is accessible in an array-like fashion' do @chromosome.should respond_to(:[]) end
      it 'has a description of solution fitness' do @chromosome.should respond_to(:fitness) end
      it 'has an unmutable length' do @chromosome.should respond_to(:length) end
      it 'can be compared to another chromosome' do @chromosome.should respond_to(:==) end
    end
    
    describe 'When seeding a new chromosome' do
      before(:each) do
        @faculties = 3.times.collect { |n| create_valid!(Faculty, :id => n) }
        @admits= 2.times.collect { |n| create_valid!(Faculty, :id => n) }

        @faculties.each { |f| f.stub!().and_return()}
        @admits.each { |a| a.stub!().and_return()}
      end

      it 'should corrrectly determine the \'length\' of the chromosome' do
        # set up faculty models and stuff correctly
        MeetingsScheduler::Chromosome.chromosome_length.should == xxx        
      end

      it 'the seed method should return a new chromosome, with the correct length' do
        # set up faculty models and stuff correctly
        @chromosome = MeetingsScheduler::Chromosome.seed
        @chromosome.class.should == MeetingsScheduler::Chromosome
        @chromosome.length.should == xxx
      end

    end


    describe 'class method: new/initialize' do
    end
    
    describe 'class method: fitness' do
    end
    
    describe 'class method: reproduce' do
    end

    describe 'class method: seed' do
    end
    
    describe 'class method: solution_string' do
    end
    
    describe 'class method: []' do
    end
    
    describe 'class method: <=>' do
    end
      
    describe 'class method: length' do
    end
    
    describe 'class method: create_solution_string' do
    end


    describe 'fitness function score helper methods' do
      before(:each) do
        @factors_to_consider = create_valid_factors_hash
        @fitness_scores_table = create_valid_fitness_scores_table
      end
      
      describe 'class method: meeting_possible_score' do
      end
      
      describe 'class method: faculty_preference_score' do
        before(:each) do
          @admit, @faculty, @schedule_index = mock('admit'), mock('faculty'), mock('schedule_index')
        end

        it 'should return a rank-weighted score if a faculty is among an ADMIT\'s ranking' do
          @ranking = { :rank => rand(@factors_to_consider[:number_of_spots_per_admit]) }
          MeetingsScheduler::Chromosome.stub!(:find_faculty_ranking).and_return(@ranking)
          MeetingsScheduler::Chromosome.should_receive(:find_faculty_ranking).once.with(@admit, @faculty, @schedule_index)
          MeetingsScheduler::Chromosome.faculty_preference_score(@admit, @faculty, @schedule_index).should ==
            @fitness_scores_table[:faculty_ranking_weight_score] * (@factors_to_consider[:lowest_rank_possible]+1 - @ranking[:rank])
        end

        it 'should return a default score if a faculty is not among an ADMIT\'s ranking' do
          MeetingsScheduler::Chromosome.stub!(:find_faculty_ranking).and_return nil
          MeetingsScheduler::Chromosome.should_receive(:find_faculty_ranking).once.with(@admit, @faculty, @schedule_index)          
          MeetingsScheduler::Chromosome.faculty_preference_score(@admit, @faculty, @schedule_index).should ==
            @fitness_scores_table[:faculty_ranking_default]
        end        
      end

      describe 'class method: find_faculty_ranking' do
        it 'should return the FACULTY\'s ranking that contains the admit' do
          @faculty_id = @factors_to_consider[:faculties].keys.shuffle.shuffle.fetch(0)
          @faculty = { :id => @faculty_id }
          @ranking = { :faculty_id  => @faculty_id }
          @admit = { :rankings => (rand(20).times{ |id| { :faculty_id => "not an id #{id}" }} + [@ranking]).shuffle.shuffle }
          MeetingsScheduler::Chromosome.find_admit_ranking(@admit, @faculty).should_return(@ranking)
        end
      end
      
      describe 'class method: admit_preference_score' do
        before(:each) do
          MeetingsScheduler::Chromosome.should_receive(:find_admit_ranking).once.with(@admit, @faculty)
          @meeting_solution, @admit, @faculty, @schedule_index = mock('meeting_solution'), mock('admit'), mock('faculty'), mock('schedule_index')
          @ranking = { :rank => rand(@factors_to_consider[:number_of_spots_per_admit]) }
        end
        
        it 'should return a rank-weighted score if an admit is among a FACULTY\'s ranking' do
          MeetingsScheduler::Chromosome.stub!(:one_on_one_score).and_return(0)
          MeetingsScheduler::Chromosome.stub!(:mandatory_meeting_score).and_return(0)          
          MeetingsScheduler::Chromosome.stub!(:find_admit_ranking).and_return(@ranking)
          MeetingsScheduler::Chromosome.admit_preference_score(@meeting_solution, @admit, @faculty, @schedule_index).should ==
            @fitness_scores_table[:admit_ranking_weight_score] * (@factors_to_consider[:lowest_rank_possible]+1 - @ranking[:rank])
        end

        it 'should further comput one-on-one score mandatory-meeting scores if an admit is among a FACULTY\'s ranking' do
          @one_on_one_score, @mandatory_meeting_score = rand(20), rand(20)
          MeetingsScheduler::Chromosome.stub!(:one_on_one_score).and_return(@one_on_one_score)
          MeetingsScheduler::Chromosome.stub!(:mandatory_meeting_score).and_return(@mandatory_meeting_score)
          MeetingsScheduler::Chromosome.stub!(:find_admit_ranking).and_return(@ranking)
          MeetingsScheduler::Chromosome.should_receive(:one_on_one_score).once.with(@meeting_solution, @admit, @faculty, @ranking, @schedule_index)
          MeetingsScheduler::Chromosome.should_receive(:mandatory_meeting_score).once.with(@ranking)
          MeetingsScheduler::Chromosome.admit_preference_score(@meeting_solution, @admit, @faculty, @schedule_index).should ==
            @fitness_scores_table[:admit_ranking_weight_score] * (@factors_to_consider[:lowest_rank_possible]+1 - @ranking[:rank]) +
            @one_on_one_score + @mandatory_meeting_score
        end
        
        it 'should return a default score if an admit is not among a FACULTY\'s ranking' do
          MeetingsScheduler::Chromosome.stub!(:find_admit_ranking).and_return nil          
          MeetingsScheduler::Chromosome.admit_preference_score(@meeting_solution, @admit, @faculty, @schedule_index).should ==
            @fitness_scores_table[:admit_ranking_default]
        end
      end

      describe 'class method: find_admit_ranking' do
        it 'should return the FACULTY\'s ranking that contains the admit' do
          @admit_id = @factors_to_consider[:attending_admits].keys.shuffle.shuffle.fetch(0)
          @admit = { :id => @admit_id }
          @ranking = { :admit_id  => @admit_id }
          @faculty = { :rankings => (rand(20).times{ |id| { :admit_id => "not an id #{id}" }} + [@ranking]).shuffle.shuffle }          
          MeetingsScheduler::Chromosome.find_admit_ranking(@admit, @faculty).should_return(@ranking)
        end
      end
      
      describe 'class method: area_match_score' do
        it 'should return the appropriate points when a faculty\'s areas of research matches one of an admit\'s areas of interest' do
          @faculty = { :area => 'subjectA'}
          @admit = { :area1 => 'subjectA', :area2 => 'subjectC' }
          MeetingsScheduler::Chromosome.area_match_score(@admit, @faculty).should == @fitness_scores_table[:area_match_score]
        end

        it 'should return the appropriate default when a faculty\'s areas of research does not match any one of an admit\'s areas of interest' do
          @faculty = { :area => 'subjectA'}
          @admit = { :area1 => 'subjectB', :area2 => 'subjectC' }
          MeetingsScheduler::Chromosome.area_match_score(@admit, @faculty).should == @fitness_scores_table[:area_match_default]
        end
      end
      
      describe 'class method: one_on_one_score' do        
        before(:each) do
          @meeting_solution, @admit, @faculty  = mock('meeting_solution'), mock('admit'), mock('faculty')
          @schedule_index, @people_in_meeting = mock('schedule_index'), mock('people_in_meeting')
          MeetingsScheduler::Chromosome.stub!(:people_in_meeting).and_return(@people_in_meeting)          
        end
        
        it 'should return a score when a FACULTY\'s admit ranking request for one-to-one meeting has been met' do
          @ranking = { :one_on_one => true }
          MeetingsScheduler::Chromosome.stub!(:only_one_person_in_meeting).and_return true
          MeetingsScheduler::Chromosome.one_on_one_score(@meeting_solution, @admit, @faculty, @ranking, @schedule_index).should ==
            @fitness_scores_table[:one_on_one_score]
        end
        
        it 'should return a penalty when a FACULTY\'s admit ranking request for one-to-one meeting has not been met' do
          @ranking = { :one_on_one => true}
          MeetingsScheduler::Chromosome.stub!(:only_one_person_in_meeting).and_return false
          MeetingsScheduler::Chromosome.one_on_one_score(@meeting_solution, @admit, @faculty, @ranking, @schedule_index).should ==
            @fitness_scores_table[:one_on_one_penalty]
        end
        
        it 'should return a default score when a FACULTY\'s admit ranking did not request for a one-to-one meeting' do
          @ranking = { :one_on_one => false}
          MeetingsScheduler::Chromosome.one_on_one_score(@meeting_solution, @admit, @faculty, @ranking, @schedule_index).should ==
            @fitness_scores_table[:one_on_one_default]
        end
      end

      describe 'class method: get_people_in_meeting' do
        it 'should return just a subset of admit_id\'s that are in a specific timeslot for a specific faculty' do
          @factors_to_consider = create_valid_factors_hash
          @length = @factors_to_consider[:total_number_of_seats]
          MeetingsScheduler::Chromosome.set_factors_to_consider(@factors_to_consider)
          @meeting_solution = MeetingsScheduler::Chromosome.new(:solution_string => (0...@length).collect).meeting_solution
          
          @faculty_id = @factors_to_consider[:faculties].keys.shuffle.shuffle.fetch(0)
          @faculty = { :id => @faculty_id }
          @schedule_index = rand(@factors_to_consider[:faculties][:faculty_id][:schedule].count)
          
          MeetingsScheduler::Chromosome.get_people_in_meeting(@meeting_solution, @faculty, @schedule_index).should ==
            @meeting_solution.find_all{ |n| n.faculty_id == faculty[:id] and n.schedule_index == schedule_index }.collect{ |n| n.admit_id }
        end        
      end

      describe 'class method: only_one_person_in_meeting' do
        before(:each) do
          @admit = { :id => 1 }
        end
        
        it 'should return true if the admit\'s id is the only unique one in an array of admit_id\'s, excluding nils' do        
          @people_in_meeting = (Array.new(19) + [1]).shuffle.shuffle
          MeetingsScheduler::Chromosome.only_one_person_in_meeting(@people_in_meeting, @admit).should == true
        end
        
        it 'should return false if the admit\'s id is not the only unique id in an array of admit_id\'s' do
          @people_in_meeting = (Array.new(18) + (1..2).collect).shuffle.shuffle
          MeetingsScheduler::Chromosome.only_one_person_in_meeting(@people_in_meeting, @admit).should == false          
        end
        
        it 'should return false if the admit\'s id is not in an array of admit_id\'s' do
          @people_in_meeting = (Array.new(19) + [2]).shuffle.shuffle
          MeetingsScheduler::Chromosome.only_one_person_in_meeting(@people_in_meeting, @admit).should == false
        end
      end
      
      describe 'class method: mandatory_meeting_score' do
        [true, false].each do |val|
          it "should return the appropriate points for whether a FACULTY\'s admit ranking is marked #{val}" do
            @ranking = { :mandatory => val }
            MeetingsScheduler::Chromosome.mandatory_meeting_score(@ranking).should == val ? @fitness_scores_table[:mandatory_score] :
              @fitness_scores_table[:mandatory_default]
          end
        end
      end
    end
    
    describe 'reproduction helper methods' do
      before(:each) do
        @factors_to_consider = create_valid_factors_hash
        @length = @factors_to_consider[:total_number_of_seats]
        MeetingsScheduler::Chromosome.set_factors_to_consider(@factors_to_consider)
        @parent1 = MeetingsScheduler::Chromosome.new(:solution_string => (0...@length).collect)
        @parent2 = MeetingsScheduler::Chromosome.new(:solution_string => (0...@length).collect)
      end
    
      describe 'class method: single_crossover' do
        it 'should return a new chromosome with the proper single swap' do
          @splice_index = rand(@length)
          @child = MeetingsScheduler::Chromosome.single_crossover(@parent1, @parent2, @splice_index)
          @child.class.should == MeetingsScheduler::Chromosome
          @child.should == MeetingsScheduler::Chromosome.new(@parent1[0...@splice_index] + @parent2[@splice_index..-1])
        end   
      end

      describe 'class method: double_crossover' do
        it 'should return a new chromosome with the proper double swap' do
          @index1, @index2 = MeetingsScheduler::Chromosome.pick_two_random_indexes(@chromosome)
          @child = MeetingsScheduler::Chromosome.single_crossover(@parent1, @parent2, @index1, @index2)
          @child.class.should == MeetingsScheduler::Chromosome
          @child.should == MeetingsScheduler::Chromosome.new(@parent1[0...@index1] + parent2[@index1...@index2] + parent1[@index2..-1])
        end
      end
    end
    
    describe 'mutation helper methods' do
      before(:each) do
        @factors_to_consider = create_valid_factors_hash
        @length = @factors_to_consider[:total_number_of_seats]
        MeetingsScheduler::Chromosome.set_factors_to_consider(@factors_to_consider)
        @chromosome = MeetingsScheduler::Chromosome.new(:solution_string => (0...@length).collect)
      end
      
      describe 'class method: reverse_two_adjacent_sequences' do                 
        it 'should return a new chromosome with two adjacent sequences reversed, given a chromosome' do
          @index = rand(@length)
          @mutant = MeetingsScheduler::Chromosome.reverse_two_adjacent_sequences(@chromosome, @index)
          @mutant.class.should == MeetingsScheduler::Chromosome
          @mutant.should == MeetingsScheduler::Chromosome.new(@mutant[0...@index] + @mutant[@index..@index+1].reverse + @mutant[@index1+1..-1])
        end
      end    
      
      describe 'class method: chromosomal_inversion' do
        it 'should return a new chromosome with proper inversion, given a chromosome' do
          @index1, @index2 = MeetingsScheduler::Chromosome.pick_two_random_indexes(@chromosome)
          @mutant = MeetingsScheduler::Chromosome.chromosomal_inversion(@chromosome, @index1, @index2)
          @mutant.class.should == MeetingsScheduler::Chromosome
          @mutant.should == MeetingsScheduler::Chromosome.new(@mutant[0...@index1] + @mutant[@index1..@index2].reverse + @mutant[@index1+1..-1])
        end
      end
      
      describe 'class method: point_mutation' do
        it 'should return a new chromosome with proper mutation, given a chromosome' do
          @index = rand(@length)
          @mutant = MeetingsScheduler::Chromosome.point_mutation(@chromosome, @index)
          @mutant.class.should == MeetingsScheduler::Chromosome
          @factors_to_consider[:attending_admits].keys.include?(@mutant[@index]).should == true
          (@mutant[0...@index]+@mutant[@index+1..-1]).should == @chromosome[0...@index]+@chromosome[@index+1..-1]
        end
      end
      
      describe 'class method: ok_to_mutate' do
        it 'should return false if the normalized fitness is good enough' do
          @normalized_fitness, @random = rand, rand
          @chromosome.normalized_fitness = @normalized_fitness
          MeetingsScheduler::Chromosome.stub!(:random).and_return @random
          MeetingsScheduler::Chromosome.ok_to_mutate(chromosome).should == (@random < ((1 - chromosome.normalized_fitness) * 0.3)) ? true : false
        end
      end
    end
    
    describe 'class method: random' do
      it 'should choose random number between 0 and 1, exclusive' do  (0...1).include?(Chromosome.random).should == true end
      it 'should take parameter and return an integer' do
        r = MeetingsScheduler::Chromosome.random(100)
        (0...100).include?(r).should == true
        r.integer?.should == true
      end    
    end  

    describe 'class method: pick_two_random_indexes' do
      before(:each) do
        @length = rand(100)
        chromosome = mock('MeetingsScheduler::Chromosome', :length => @length)
        index1, index2 = MeetingsScheduler::Chromosome.pick_two_random_indexes(sample_chromosome)
      end
      it 'should have the second integer be larger than the first' do index2.should > index1+1 end
      it 'should be integers in the proper range' do
        index1.should > 0
        index1.should < @length-3
        index2.should > 2
        index2.should < @length-1
      end      
    end
    
  end


  describe MeetingsScheduler::Nucleotide do
    describe 'Nucleotide attributes' do
      before(:each) do
        @nucleotide = MeetingsScheduler::Nucleotide.new([1,2,3])
      end      
      it 'has a faculty_id' do @nucleotide.should respond_to(:faculty_id) end
      it 'has a schedule_index' do @nucleotide.should respond_to(:schedule_index) end
      it 'has an admit_id' do @nucleotide.should respond_to(:admit_id) end
    end
  end
=end

end

def create_valid_factors_hash(hash=nil)
  return { }.merge(hash)
end
