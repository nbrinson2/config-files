# TTB project aliases and helpers

alias artemisdown="docker compose -f ~/workspace/ttb/my-ttb-main/src/main/docker/activemq.yml down"
alias artemisup="docker compose -f ~/workspace/ttb/my-ttb-main/src/main/docker/activemq.yml up -d"
alias cdauth="cd ~/workspace/ttb/my-ttb-authorization-api"
alias cdchem="cd ~/workspace/ttb/chemist-certificate-data-management-api"
alias cdclaims="cd ~/workspace/ttb/claims-management-service-api"
alias cdexport="cd ~/workspace/ttb/export-certificate-data-management-api"
alias cdforeign="cd ~/workspace/ttb/foreign-producer-data-management-api"
alias cdform="cd ~/workspace/ttb/form-data-management-api"
alias cdidam="cd ~/workspace/ttb/idam-management-api"
alias cdimdata="cd ~/workspace/ttb/im-data-management-api"
alias cdims="cd ~/workspace/ttb/ims2"
alias cdintake="cd ~/workspace/ttb/intake-token-service-api"
alias cditds="cd ~/workspace/ttb/itds-data-management-api"
alias cdlogs="cd ~/workspace/ttb/nohup-logs"
alias cdmain="cd ~/workspace/ttb/my-ttb-main"
alias cdmessaging="cd ~/workspace/ttb/messaging-data-management-api"
alias cdoutbound="cd ~/workspace/ttb/outbound-email-service-api"
alias cdpermits="cd ~/workspace/ttb/permits-data-management-api"
alias cdpermitsui="cd ~/workspace/ttb/my-ttb-permits-ui"
alias cdprocess="cd ~/workspace/ttb/process-flow-service-api"
alias cdpublic="cd ~/workspace/ttb/public-labels-api"
alias cdshared="cd ~/workspace/ttb/shared-libs"
alias cdtax="cd ~/workspace/ttb/tax-ref-data-management-api"
alias javatest="./mvnw jacoco:prepare-agent-integration verify jacoco:report > /home/nbrinson2/workspace/ttb/logs/nohup-logs/nohup-log-integration-test.log 2>&1"
alias mainjava="./mvnw -P-webapp jacoco:prepare-agent-integration verify jacoco:report"
alias tf="testfile"
alias trivys="trivy filesystem . --format json --output trivy-scan.json"

dpost() {
    FILE_PATH=~/workspace/ttb/my-ttb-main/src/main/docker/postgresql.yml
    docker compose -f "$FILE_PATH" up -d
}

gkey() {
    ssh-keygen -t ed25519 -C "nick.brinson@metric5.com" -f ~/.ssh/ttb_ed25519
}

gstat() {
    local parent_dir=~/workspace/ttb

    if [[ ! -d "$parent_dir" ]]; then
        echo "The directory $parent_dir does not exist."
        return 1
    fi

    printf "%-42s  %-15s  %-20s\n" "Folder Name" "Branch Name" "Status"
    printf "%s\n" "--------------------------------------------------------------------------------"

    for dir in "$parent_dir"/*; do
        if [[ -d "$dir/.git" ]]; then
            cd "$dir" || continue
            local branch_name
            branch_name=$(git rev-parse --abbrev-ref HEAD)
            local status
            status=$(git status --porcelain)
            if [[ -z "$status" ]]; then
                status="Clean"
            else
                status="Changes present"
            fi
            printf "%-42s  %-15s  %-20s\n" "$(basename "$dir")" "$branch_name" "$status"
            cd - >/dev/null
        fi
    done
}

ports() {
    local base_dir="/home/nbrinson2/workspace/ttb"
    declare -a services=("banking-management-service-api" "claims-management-service-api" "content-management-api" "export-certificate-data-management-api" "foreign-producer-data-management-api" "form-data-management-api" "idam-management-api" "im-data-management-api" "IMS2" "intake-data-management-api" "intake-token-service-api" "itds-data-management-api" "messaging-data-management-api" "mock-ponl-service-api" "my-ttb-authorization-api" "outbound-email-service-api" "process-flow-service-api" "tax-ref-data-management-api")
    declare -a services_awk=("banking-management-service-api" "content-management-api" "export-certificate-data-management-api" "idam-management-api" "messaging-data-management-api" "mock-ponl-service-api" "my-ttb-authorization-api")
    local temp_file
    temp_file=$(mktemp)

    for service in "${services[@]}"; do
        local config_file="${base_dir}/${service}/src/main/resources/config/application-dev.yml"

        if [[ -f "$config_file" ]]; then
            local port
            port=$(grep "port: \\$" "$config_file" | awk -F ': ' '{print $2}')
            port=${port//\$\{SERVER_PORT:/}
            port=${port//\}/}
            port=${port//\'/}

            for svc in "${services_awk[@]}"; do
                if [[ "$service" == "$svc" ]]; then
                    port=$(awk '/^server:/{flag=1; next} /port:/{if(flag){print $2; exit}}' "$config_file")
                fi
            done

            echo "$port - $service" >>"$temp_file"
        else
            echo "Configuration file for $service not found."
        fi
    done

    sort -n "$temp_file" | tail -n +3 | while read -r line; do
        echo "${line}"
    done

    rm "$temp_file"
}

replace_quotes() {
    local target="$1"
    local sedExpr='s/\[([^]]+)\]=\"'\''([^'\'']+)'\''\"/\1="\2"/g'

    if [ -d "$target" ]; then
        find "$target" -type f -name "*.html" -exec sed -i -E "$sedExpr" {} +
    elif [ -f "$target" ]; then
        sed -i -E "$sedExpr" "$target"
    else
        echo "Error: $target is not a valid file or directory"
        return 1
    fi
}

res() {
    local service=$1
    local full_service_name
    local pid
    local new_pid

    case $service in
    angular) full_service_name="my-ttb-main" ;;
    auth) full_service_name="my-ttb-authorization-api" ;;
    bank) full_service_name="banking-management-service-api" ;;
    chem) full_service_name="chemist-certificate-data-management-api" ;;
    claims) full_service_name="claims-management-service-api" ;;
    content) full_service_name="content-management-api" ;;
    export) full_service_name="export-certificate-data-management-api" ;;
    foreign) full_service_name="foreign-producer-data-management-api" ;;
    form) full_service_name="form-data-management-api" ;;
    idam) full_service_name="idam-management-api" ;;
    imdata) full_service_name="im-data-management-api" ;;
    ims) full_service_name="ims2" ;;
    itds) full_service_name="itds-data-management-api" ;;
    main) full_service_name="my-ttb-main" ;;
    messaging) full_service_name="messaging-data-management-api" ;;
    outbound) full_service_name="outbound-email-service-api" ;;
    permits) full_service_name="permits-data-management-api" ;;
    process) full_service_name="process-flow-service-api" ;;
    tax) full_service_name="tax-ref-data-management-api" ;;
    *)
        echo "Invalid service name: $service"
        return 1
        ;;
    esac

    if [ "$service" = "angular" ]; then
        pid=$(ps aux | grep "[n]g serve --hmr" | sort -rk10,10 | awk 'NR==1{print $2}')
    else
        pid=$(grep "$full_service_name" ~/workspace/ttb/logs/running_services.log | awk '{print $1}')
    fi

    if [ -n "$pid" ]; then
        kill "$pid"
        echo "Service $full_service_name with PID $pid has been killed."
    else
        echo "Service $full_service_name not found."
    fi

    sleep 2
    cd ~/workspace/ttb/"$full_service_name" || exit

    if [ "$full_service_name" = "ims2" ]; then
        echo "Starting $full_service_name (special config) in the background..."
        nohup ./mvnw -s ~/workspace/ttb/ims2/settings.xml &>"$HOME/workspace/ttb/logs/nohup-logs/nohup-log-$full_service_name" 2>&1 &
    elif [ "$service" = "angular" ]; then
        echo "Starting angular server in the background..."
        npm start >"$HOME/workspace/ttb/logs/nohup-logs/nohup-log-angular" 2>&1 &
    else
        echo "Starting $full_service_name in the background..."
        nohup ./mvnw &>"$HOME/workspace/ttb/logs/nohup-logs/nohup-log-$full_service_name" 2>&1 &
    fi

    sleep 2

    if [ "$service" = "angular" ]; then
        new_pid=$(ps aux | grep "[n]g serve --hmr" | sort -rk10,10 | awk 'NR==1{print $2}')
        echo "Angular server started with PID - $new_pid."
    else
        new_pid=$!
    fi

    if [ "$service" = "angular" ]; then
        full_service_name="angular-server"
    fi

    if grep -q "$full_service_name" ~/workspace/ttb/logs/running_services.log; then
        sed -i "s/^.*$full_service_name \((.*)\)$/$new_pid - $full_service_name \1/" ~/workspace/ttb/logs/running_services.log
        echo "Updated $full_service_name with new PID $new_pid in running_services.log."
    else
        current_branch=$(git rev-parse --abbrev-ref HEAD)
        echo "$new_pid - $full_service_name (${current_branch})" >>~/workspace/ttb/logs/running_services.log
        echo "Added $full_service_name with PID $new_pid to running_services.log."
    fi
}

sbran() {
    main_directory="$HOME/workspace/ttb"

    for dir in "$main_directory"/*; do
        if [ -d "$dir" ]; then
            cd "$dir" || continue
            if git rev-parse --git-dir >/dev/null 2>&1; then
                branch=$(git branch --show-current)
                echo "$(basename "$dir") - $branch"
            else
                echo "$(basename "$dir") - Not a Git repository"
            fi
            cd "$main_directory" || exit
        fi
    done
}

tang() {
    base="$1"
    MODULE_FILE="/home/nbrinson2/workspace/ttb/my-ttb-main/src/main/webapp/app/permits/permits.module.ts"

    touch "$base.component.html"
    touch "$base.component.scss"

    component_class=$(echo "$base" | sed -r 's/(^|-)(\w)/\U\2/g')Component

    cat <<EOF >"$base.component.ts"
import { Component } from "@angular/core";

@Component({
  selector: 'ttb-$base',
  templateUrl: './$base.component.html',
  styleUrls: ['./$base.component.scss'],
})
export class $component_class {}
EOF

    cat <<EOF >"$base.component.spec.ts"
import { ComponentFixture, TestBed } from "@angular/core/testing";
import { $component_class } from "./$base.component";

describe('$component_class', () => {
  let component: $component_class;
  let fixture: ComponentFixture<$component_class>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [$component_class],
      imports: [],
      providers: [],
    }).compileComponents();

    fixture = TestBed.createComponent($component_class);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });
});
EOF

    import_line="import { $component_class } from 'app/permits/$base/$base.component';"

    if grep -q "$component_class" "$MODULE_FILE"; then
        echo "$component_class is already present in $MODULE_FILE, skipping update."
    else
        ngmodule_line=$(grep -n "@NgModule" "$MODULE_FILE" | head -n1 | cut -d: -f1)
        insert_line=$((ngmodule_line - 1))
        sed -i "${insert_line}i\\$import_line" "$MODULE_FILE"
        sed -i "/declarations: \[/,/\],/ s/\(\s*\]\)/    $component_class,\n\1/" "$MODULE_FILE"
        sed -i "/exports: \[/,/\],/ s/\(\s*\]\)/    $component_class,\n\1/" "$MODULE_FILE"
    fi
}

testfile() {
    local input="$*"

    if [[ "$input" == *.java ]]; then
        local classname
        classname=$(basename "$input" .java)
        echo "→ Running Java unit test: $classname (output logged)"
        ./mvnw -Dtest="$classname" test >/home/nbrinson2/workspace/ttb/logs/nohup-logs/nohup-log-java-test.log 2>&1
        return
    fi

    if [[ "$input" == *spec* ]]; then
        ng test --test-path-pattern="$input" -i --run-in-band --log-heap-usage --detect-open-handles --coverage
    elif [[ "$input" == *IT* ]] || [[ "$input" == *IT#* ]]; then
        COMMAND="./mvnw jacoco:prepare-agent-integration verify -Dit.test=\"$input\" jacoco:report > /home/nbrinson2/workspace/ttb/logs/nohup-logs/nohup-log-integration-test.log 2>&1"
        echo "$COMMAND"
        eval "$COMMAND"
    else
        echo "→ Running Java unit test: $input (output logged)"
        ./mvnw -Dtest="$input" test >/home/nbrinson2/workspace/ttb/logs/nohup-logs/nohup-log-java-test.log 2>&1
    fi
}
